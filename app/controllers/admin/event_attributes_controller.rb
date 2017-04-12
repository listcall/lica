class Admin::EventAttributesController < ApplicationController

  before_action :authenticate_owner!

  def index
    @title = 'Event Attributes'
    @attributes = current_team.event_attributes.to_a
  end

  def create
    @attribute  = EventAttribute.new(name: unique_name, label: unique_label, position: 0)
    if @attribute.valid?
      EventAttributesSvc.new(current_team).add_obj(@attribute)
      redirect_to '/admin/event_attributes', notice: "Added #{@attribute.label}"
    else
      redirect_to '/admin/event_attributes', alert: 'There was an error creating the attribute...'
    end
  end

  def update
    EventAttributesSvc.new(current_team).update(params)
    render :plain => 'OK'
  end

  def destroy
    EventAttributesSvc.new(current_team).destroy(params)
    redirect_to '/admin/event_attributes', :notice => "#{params[:id]} was deleted."
  end

  def sort
    EventAttributesSvc.new(current_team).sort(params)
    render :plain => 'OK'
  end

  private

  def unique_name
    unique_string current_team.event_attributes.to_a.map {|x| x.name}
  end

  def unique_label
    unique_string current_team.event_attributes.to_a.map {|x| x.label}
  end

  def unique_string(strings)
    return 'TBD' unless strings.include? 'TBD'
    idx = 1
    while (strings.include?("TBD#{idx}")) || idx > 100
      idx += 1
    end
    "TBD#{idx}"
  end

end
