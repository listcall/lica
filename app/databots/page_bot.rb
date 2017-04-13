# new_pager

class PageBot

  attr_reader :team

  def initialize(team)
    @team = team
  end

  def select_list
    team.partners.map do |lteam|
      team_selection(lteam)
    end.flatten.to_json
  end

  private

  def team_selection(lteam)
    team_roles(lteam) + team_members(lteam)
  end

  def team_roles(lteam)
    # lteam.member_roles.to_data.values.map do |role|
    lteam.roles.map do |role|
      next if lteam.memberships.in_role(role.label).count == 0
      {
        'value'     => role.name.parameterize.underscore,
        'team_icon' => lteam.icon_path,
        'tokens'    => [role.name.parameterize.underscore],
        'tag_id'    => "#{lteam.id}_#{role.label}"
      }
    end.select {|x| x.present?}
  end

  def team_members(lteam)
    lteam.memberships.includes(:user).active.by_last_name.map do |member|
      {
        'value'     => member.full_name,
        'team_icon' => member.team.icon_path,
        'tokens'    => [member.full_name, member.last_name],
        'tag_id'    => "#{lteam.id}_#{member.id}"
      }
    end
  end
end