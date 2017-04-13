class Ajax::EventChildrenController < ApplicationController

  before_action :authenticate_reserve!

  respond_to :json, :html

  def create
    parent_event_id = params['pk']
    parent_event    = Event.find(parent_event_id)
    child_team_id, child_event_id = params['value'].split('_')
    child_team   = Team.find(child_team_id)
    child_event  = if child_event_id == 'new'
                     args = {
                       team_id: child_team.id,
                       start: parent_event.start,
                       title: parent_event.title,
                       location_name:    parent_event.location_name,
                       location_address: parent_event.location_address,
                       lat:              parent_event.lat,
                       lon:              parent_event.lon
                     }
                     child = Event.create(args)
                     Event::Period.create(event_id: child.id, parent: parent_event.periods.first)
                     child
                   else
                     Event.find(child_event_id)
                   end
    child_event.parent = parent_event
    child_event.save
    parent_event.save
    render plain: 'OK'
  end

  def destroy
    event = Event.find(params[:event_id])
    event.parent = nil
    event.save
    render plain: 'OK'
  end

end
