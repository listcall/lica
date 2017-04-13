class ServiceBot

  attr_reader :team

  def initialize(team)
    @team = team
  end

  def member_list
    team.memberships.includes(:user).active.map do |mem|
      {
        'user_name'  => mem.user_name,
        'avatar'     => mem.avatar,
        'first_name' => mem.first_name,
        'last_name'  => mem.last_name,
        'value'      => mem.full_name
      }
    end.to_json
  end

  def service_list
    team.svcs.map do |svc|
      {
        'id'    => svc.id,
        'name'  => svc.name,
        'color' => svc.color
      }
    end.to_json
  end

  def busy_list
    # mem_ids = team.memberships.active.select(:id).pluck(:id)
    # Svc::Participant.where(member_id: mem_ids).between()
    ["TBD"]
  end
end