require 'ext/date'
require 'ostruct'

class Rep::Ctx::Base < Rep::Ctx

  attr_accessor :member, :team, :alt

  def initialize(args = {})
    @member    = args.delete(:member)
    @team      = args.delete(:team)
    @alt       = args
  end

  def ctx
    ctx = {}
    ctx['team']    = team_data
    ctx['member']  = member_data
    ctx['alt']     = alt
    ctx
  end

  private

  def team_data
    {
      id:       team.id,
      name:     team.name,
      acronym:  team.acronym,
      logo_url: 'TBD'
    }
  end

  def member_data
    {
      id: member.id,
      first_name: member.first_name,
      last_name:  member.last_name,
      user_name:  member.user_name,
    }
  end
end
