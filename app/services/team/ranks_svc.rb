class Team::RanksSvc

  attr_accessor :current_team

  El = Struct.new(:acronym, :rights)

  def initialize(current_team = nil)
    @current_team = current_team
  end

  def add(rank)
    rank.update_attributes(team_id: current_team.id)
  end

  def update(params)
    return unless (rank = Team::Rank.find(params['id']))
    name    = params['name']
    new_val = params['value']
    old_val = rank.send(name.to_sym)
    rank.update_attribute(name.to_sym, new_val)
    return unless name == 'acronym'
    current_team.memberships.where(rank: old_val).update_all(rank: new_val)
  end

  def destroy(params)
    if params[:id]
      rank = Team::Rank.find(params[:id])
      return if rank.nil?
      rank.destroy
    end
  end

  def sort(params)
    old_ranks  = gen_old_ranks
    new_ranks  = gen_new_ranks(params[:rank])
    swapped    = find_swapped(old_ranks, new_ranks)
    changed    = find_changed(old_ranks, new_ranks)
    update_ranks(old_ranks, new_ranks)
    update_member_credentials_for((swapped + changed).uniq)
  end

  private

  def gen_old_ranks
    current_team.ranks.order(:sort_key)
  end

  def gen_new_ranks(list)
    right = 'owner'
    output = []
    tags   = Right.options
    list.map(&:strip).each do |item|
      if tags.include? item
        right = item
      else
        output << [item, right]
      end
    end
    convert_to_el(output)
  end

  def find_swapped(old_ranks, new_ranks)
    swapped = []
    old_ranks.each_with_index do |rank, idx|
      swapped << rank if new_ranks[idx].acronym != rank.acronym
    end
    swapped
  end

  def find_changed(old_ranks, new_ranks)
    result = old_ranks.find do |rank|
      rank.rights != lookup(new_ranks, rank.acronym).rights
    end
    Array(result)
  end

  # ----- methods that update -----

  def update_ranks(old_ranks, new_ranks)
    new_ranks.each_with_index do |rank, idx|
      opts = {sort_key: idx + 1, rights: rank.rights}
      lookup(old_ranks, rank.acronym).update_attributes(opts)
    end
  end

  def update_member_credentials_for(ranks)
    keys = ranks.map(&:acronym)
    mems = current_team.memberships.includes(:user).where(rank: keys)
    ActiveRecord::Base.no_touching do
      mems.each do |mem|
        mem.rank_will_change!
        mem.save
      end
    end
    current_team.touch
  end

  # ----- utility methods -----

  def lookup(list, acronym)
    list.find {|rank| rank.acronym == acronym}
  end

  def convert_to_el(list)
    list.map {|el| El.new(*el)}
  end
end