class Ajax::EventParentsController < ApplicationController

  before_action :authenticate_reserve!

  respond_to :json, :html

  def create
    event_id = params['pk']
    event    = Event.find(event_id)
    parent_team_id, parent_event_id = params['value'].split('_')
    parent_team = Team.find(parent_team_id)
    parent_event = if parent_event_id == 'new'
                     args = {
                             team_id: parent_team.id,
                               start: event.start,
                               title: event.title,
                       location_name: event.location_name,
                    location_address: event.location_address
                             }
                     Event.create(args)
                   else
                     Event.find(parent_event_id)
                   end
    parent_event.save
    parent_event.reload
    event.parent = parent_event
    event.save
    parent_event.save
    render text: 'OK'
  end

  def destroy
    event = Event.find(params[:event_id])
    event.periods.each do |period|
        period.update_attributes parent: nil
    end
    event.update_attributes parent: nil
    render text: 'OK'
  end

end
