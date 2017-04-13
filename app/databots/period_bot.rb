class PeriodBot

  attr_reader :member, :period, :event, :team

  def initialize(member, period)
    @member = member
    @period = period
    @event  = period.event
    @team   = event.team
    @participants = @period.participants.includes(:membership)
  end

  def team_data
    {
      id:           team.id                     ,
      member_ranks: team.ranks.pluck(:acronym)  ,
      event_roles:  [{value: '', text: ''}] + team.event_roles.to_a.map do |er|
        {value: er.id, text: "#{er.id} - #{er.name}"}
      end
    }.to_json
  end

  def member_data
    {
      id:           member.id          ,
      time_button:  member.time_button ,

    }.to_json
  end

  def period_data
    {
      id:         period.id         ,
      position:   period.position   ,
    }.to_json
  end

  def participant_list
    @participants.to_a.map do |part|
      {
        id:             part.id             ,
        avatar:         part.avatar         ,
        user_name:      part.user_name      ,
        full_name:      part.full_name      ,
        departed_at:    part.departed_at    ,
        returned_at:    part.returned_at    ,
        signed_in_at:   part.signed_in_at   ,
        signed_in_out:  part.signed_out_at  ,
      }
    end.to_json
  end

  def membership_list
    team.memberships.guest.map do |mem|
      [
        mem.id          ,
        mem.full_name   ,
      ]
    end.to_json
  end

  def memlist
    res = team_list.map {|lteam| team_memlist(lteam) }
    res.flatten.to_json
  end

  def team_list
    return [team] unless period.has_children?
    ([team] + period.descendants.map {|period| period.event.team}).uniq
  end

  def team_memlist(lcl_team)
    lcl_team.memberships.guest.map do |mem|
      {
        'value'     => "#{mem.full_name} (#{mem.user_name} - #{mem.rank})",
        'team_acro' => mem.team.acronym,
        'team_icon' => mem.team.icon_path,
        'avatar'    => mem.avatar,
        'mem_name'  => mem.full_name,
        'mem_rank'  => mem.rank,
        'mem_id'    => mem.id,
        'user_name' => mem.user_name,
        'child'     => lcl_team != team,
        'tokens'    => [mem.first_name, mem.last_name, mem.user_name],
      }
    end
  end

end