class Inbound::Util::Lookup

  attr_reader :team

  def initialize(team = nil)
    @team = team
  end

  def match_recipient(inbound_address)
    all_keys.find {|item| inbound_address.downcase.match item[:address_regex]}
  end
  alias_method :match, :match_recipient

  def match_recipients(inbound_address)
    all_keys.select {|item| inbound_address.downcase.match item[:address_regex]}
  end

  private

  def page_keys
    pgr_reg = /^pager$/
    [{address_regex: pgr_reg, type: 'page_reply', id: 'page_reply', team: @team.try(:id)}]
  end

  def membership_keys
    @team.memberships.map do |mem|
      user = mem.user
      uname = user.user_name.downcase
      fname = user.full_name.downcase.gsub(' ','_')
      adr_reg = /^(#{uname}|#{fname})s?(-member(ship)?)?$/
      {address_regex: adr_reg, type: 'membership', id: mem.id, team: @team.id}
    end
  end

  def rank_keys
    @team.ranks.pluck(:acronym).map do |rank|
      rankab  = rank.downcase
      rankfn  = 'TBD'
      adr_reg = /^(#{rankab}|#{rankfn})s?(-ranks?)?$/
      {address_regex: adr_reg, type: 'rank', id: rankab, team: @team.id}
    end
  end

  def role_keys
    # @team.member_roles.keys.map do |role|
    @team.roles.pluck(:acronym).map do |role|
      roleab  = role.downcase
      rolefn  = 'TBD'
      adr_reg = /^(#{roleab}|#{rolefn})s?(-roles?)?$/
      {address_regex: adr_reg, type: 'role', id: roleab, team: @team.id}
    end
  end

  def forum_keys
    # @team.forums.map do |forum|
    #   forumab = forum.name.downcase.gsub(' ', '_')
    #   forumtp = forum.type[2..-1].downcase
    #   adr_reg = /^#{forumab}s?(-(forum|#{forumtp})s?)?$/
    #   {address_regex: adr_reg, type: 'forum', id: forum.id, team: @team.id}
    # end
    []
  end

  def all_keys
    page_keys + membership_keys + rank_keys + role_keys + forum_keys
  end
end
