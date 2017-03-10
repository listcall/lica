class EventAttributesSvc

  def initialize(current_team)
    @current_team = current_team
  end

  def add_obj(role)
    attributes = @current_team.event_attributes
    attributes.add_obj role
    @current_team.event_attributes = attributes
    @current_team.save
  end

  def update(params)
    id   = params['id']
    name = params['name']
    attribute = @current_team.event_attributes[id]
    return if attribute.nil?
    update_membership_attributes(attribute.label, params['value']) if name == 'label'
    attribute.send("#{name}=", params['value'])
    attributes = @current_team.event_attributes
    attributes.destroy id
    attributes.add_obj attribute
    @current_team.event_attributes = attributes
    @current_team.save
  end

  def destroy(params)
    if params[:id]
      #delete_event_attributes params[:id]
      attributes = @current_team.event_attributes
      attributes.destroy params[:id]
      @current_team.event_attributes = attributes
      @current_team.save
    end
  end

  def sort(params)
    attributes = @current_team.event_attributes
    params['attribute'].each_with_index do |label, idx|
      attributes[label.strip].position = 1 + idx
    end
    @current_team.event_attributes = attributes
    @current_team.save
  end

  private

  def update_membership_attributes(old_label, new_label)
    @current_team.memberships.where('xfields ? :key', :key => old_label).to_a.each do |mem|
      value = mem.xfields[old_label]
      mem.xfields[new_label] = value
      mem.xfields.delete old_label
      mem.save
    end
  end

  def delete_membership_attributes(label)
    @current_team.memberships.where('xfields ? :key', :key => label).to_a.each do |mem|
      mem.xfields.delete label
      mem.save
    end
  end

end