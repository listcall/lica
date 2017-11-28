class Admin::EventTypesController < ApplicationController

  before_action :authenticate_member!

  def index
    @title = 'Event Types'
    @types = current_team.event_types.to_a
  end

  def create
    types = current_team.event_types
    type  = EventType.new params[:event]
    types.add_obj(type)
    current_team.event_types = types
    if current_team.valid? && current_team.save
      redirect_to '/admin/event_types', notice: "Added #{type.name}"
    else
      redirect_to '/admin/event_types', alert: 'There was a problem...'
    end
  end

  def update
    name, value = [params[:name], params[:value]]
    value = value.try(:upcase) if name.to_s == 'acronym'
    types = current_team.event_types
    type  = types[params['pk'].strip]
    oldt  = type.id
    type.send("#{name}=", value)
    current_team.event_types = types
    if type.valid? && current_team.save
      update_event_typ(oldt, value) if name.to_s == 'acronym'
      render plain: params['pk'], layout: false
    else
      render plain: validation_message(type), layout: false, status: 422
    end
  end

  def destroy
    types = current_team.event_types
    types.destroy params['id']
    current_team.event_types = types
    current_team.save
    redirect_to '/admin/event_types'
  end

  def sort
    event_types = current_team.event_types
    params['type'].each_with_index do |key, idx|
      event_types[key].position = idx + 1
    end
    current_team.event_types = event_types
    current_team.save
    render plain: 'OK', layout: false
  end

  private

  def update_event_typ(old_typ, new_typ)
    @current_team.events.where(typ: old_typ).to_a.each do |event|
      event.update_attributes typ: new_typ
    end
  end

  def validation_message(obj)
    msg1 = ActionController::Base.helpers.pluralize(obj.errors.count, 'error')
    msg2 = ' prevented this from being saved: '
    msg3 = obj.errors.full_messages.map.with_index {|msg, i| "#{i+1}) #{msg}"}.join(', ')
    msg1 + msg2 + msg3
  end

end

