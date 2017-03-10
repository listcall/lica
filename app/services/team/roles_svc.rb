class Team::RolesSvc

  attr_accessor :current_team

  def initialize(current_team = nil)
    @current_team = current_team
  end

  def add(role)
    role.update_attributes(team_id: current_team.id)
  end

  def update(params)
    return unless (role = Team::Role.find(params['id']))
    name    = params['name']
    new_val = params['value']
    old_val = role.send(name.to_sym)
    role.update_attribute name.to_sym, new_val
    update_membership_roles(old_val, new_val)   if name == 'acronym'
    update_membership_rights(role.label)        if name == 'rights'
  end

  def destroy(params)
    if params[:id]
      role = Team::Role.find(params[:id])
      return if role.nil?
      role.destroy
      update_role_scores
    end
  end

  def sort(params)
    roles = current_team.roles
    params.with_indifferent_access['role'].each_with_index do |acronym, idx|
      role = roles.find_by(acronym: acronym)
      next if role.blank?
      role.update_attribute(:sort_key, 1 + idx)
    end
    update_role_scores
  end

  private

  def update_membership_roles(old_role, new_role)
    current_team.memberships.in_role(old_role).to_a.each do |mem|
      mem.reload
      roles = mem.roles
      roles.delete old_role
      roles += [new_role]
      mem.update_column :roles, roles
    end
  end

  def update_membership_rights(role)
    current_team.memberships.where('ARRAY[?] && roles', [role]).to_a.each do |mem|
      mem.save  # triggers mem.set_rights! in before_save callback...
    end
  end

  def update_role_scores
    set_roles current_team.memberships.includes(:user).where("roles != '{}'")
  end

  def set_roles(mems)
    ActiveRecord::Base.no_touching do
      mems.each do |mem|
        mem.roles_will_change!
        mem.save
      end
    end
  end
end