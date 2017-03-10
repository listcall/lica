class MemberAttributesSvc

  def initialize(current_team)
    @current_team = current_team
  end

  def add_obj(role)
    attributes = @current_team.member_attributes
    attributes.add_obj role
    @current_team.member_attributes = attributes
    @current_team.save
  end

  def update(params)
    id   = params['id']
    name = params['name']
    attribute = @current_team.member_attributes[id]
    return if attribute.nil?
    update_membership_attributes(attribute.label, params['value']) if name == 'label'
    attribute.send("#{name}=", params['value'])
    attributes = @current_team.member_attributes
    attributes.destroy id
    attributes.add_obj attribute
    @current_team.member_attributes = attributes
    @current_team.save
  end

  def destroy(params)
    if params[:id]
      #delete_member_attributes params[:id]
      attributes = @current_team.member_attributes
      attributes.destroy params[:id]
      @current_team.member_attributes = attributes
      @current_team.save
    end
  end

  def sort(params)
    attributes = @current_team.member_attributes
    params['attribute'].each_with_index do |label, idx|
      attributes[label.strip].position = 1 + idx
    end
    @current_team.member_attributes = attributes
    @current_team.save
  end

  private

  def update_membership_attributes(old_label, new_label)
    @current_team.memberships.with_attr(old_label).to_a.each do |mem|
      attr_change(mem, old_label, new_label)
      mem.save
    end
  end

  def attr_change(mem, old_key, new_key)
    return if mem.xfields[old_key].nil?
    xf = mem.xfields
    xf[new_key] = xf[old_key]
    xf.delete(old_key)
    mem.xfields = xf
    mem.xfields_will_change!
  end

  # def delete_membership_attributes(label)
  #   @current_team.memberships.with_attr(label).to_a.each do |mem|
  #     mem.attr_del(label)
  #     mem.save
  #   end
  # end

end