class EventRolesSvc

  def initialize(current_team)
    @current_team = current_team
  end

  def add_obj(role)
    roles = @current_team.event_roles
    roles.add_obj role
    @current_team.event_roles = roles
    @current_team.save
  end

  def update(params)
    id = params['id']
    name = params['name']
    role = @current_team.event_roles[id]
    if role.nil?
      dev_log 'ROLE IS NIL!'
      return
    end
    update_membership_roles(role.label, params['value']) if name == 'label'
    role.send("#{name}=", params['value'])
    roles = @current_team.event_roles
    roles.destroy id
    roles.add_obj role
    @current_team.event_roles = roles
    @current_team.save
  end

  def destroy(params)
    if params[:id]
      roles = @current_team.event_roles
      roles.destroy params[:id]
      @current_team.event_roles = roles
      @current_team.save
    end
  end

  def sort(params)
    roles = @current_team.event_roles
    params['role'].each_with_index do |acronym, idx|
      acronym.strip!
      roles[acronym].position = 1 + idx
    end
    @current_team.event_roles = roles
    @current_team.save
  end

  private

  def update_membership_roles(old_role, new_role)
    @current_team.memberships.in_role(old_role).to_a.each do |mem|
      roles = mem.roles
      roles.delete old_role
      roles += [new_role]
      mem.update_attributes roles: roles
    end
  end

  def update_membership_rights(role, rights)
    @current_team.memberships.where(role: role).to_a.each do |mem|
      mem.set_rights!
    end
  end

end
