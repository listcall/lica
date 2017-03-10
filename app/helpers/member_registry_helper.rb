module MemberRegistryHelper

  def rank_counts
    keys = current_team.ranks.pluck(:acronym)
    keys.reduce({}) do |a, v|
      array = @members.select { |mem| mem.rank == v }
      a[v] = array.length
      a
    end.to_s.gsub(/["{}=]/,'').gsub('>',':')
  end

  def role_counts
    keys = current_team.roles.pluck(:acronym)
    keys.reduce({}) do |a, v|
      array = @members.select { |mem| mem.roles.include? v }
      a[v] = array.length
      a
    end.to_s.gsub(/["{}=]/,'').gsub('>',':')
  end

  def rights_counts
    keys = %w(owner manager active reserve guest alum inactive)
    keys.reduce({}) do |a, v|
      array = @members.select { |mem| mem.rights == v }
      a[v] = array.length
      a
    end.to_s.gsub(/["{}=]/,'').gsub('>',':')
  end
end