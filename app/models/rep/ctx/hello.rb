require 'ext/date'
require 'ostruct'

class Rep::Ctx::Hello < Rep::Ctx

  attr_accessor :member, :team, :alt

  def initialize(args = {})
    @member    = args.delete(:member)
    @team      = args.delete(:team)
    @alt       = args
  end

  def ctx
    ctx = {}
    ctx['team']         = team_data
    ctx['members']      = member_hash
    ctx['alt']          = alt
    ctx
  end

  private

  # ----- team -----------------------------------------------------------------

  def team_data
    {
      name:    @team.name,
      acronym: @team.acronym,
      logo_url: 'TBD'
    }
  end

  # ----- members --------------------------------------------------------------

  def memb_hsh(mem)
    {
      id:   mem.id,
      last_name:  mem.last_name,
      first_name: mem.first_name,
      avatar_url: mem.avatar.url(:icon)
    }
  end

  def members
    @members ||= team.memberships.includes('user').active
  end

  def member_hash
    @member_hash ||= members.reduce({}) do |hsh, mem|
      hsh[mem.id] = memb_hsh(mem)
      hsh
    end
  end
end
