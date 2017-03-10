class EventsController < ApplicationController

  before_action :authenticate_reserve!

  def index
    response.headers['Cache-Control'] = 'no-cache, no-store, max-age=0, must-revalidate'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = 'Fri, 01 Jan 1990 00:00:00 GMT'
    @current_events  = current_team.events.current
    @upcoming_events = current_team.events.upcoming
    @recent_events   = current_team.events.recent
    @all_events      = current_team.events.ordered
  end

  def show
    opts = [{:periods => :event}, {:team => :accepted_partners}]
    event = current_team.events.includes(opts).find_by(:event_ref => params[:id])
    if event.nil?
      redirect_to '/events', alert: "Not found: #{params[:id]}"
    else
      @event    = EventForm.new.with_event(event)
      @ev_times = current_team.event_types.to_data.to_json
      @select   = current_team.event_types.to_data.values.map {|x| {value: x[:acronym], text: x[:name]}}.to_json
      @event_bot = EventBot.new(@event.event)
    end
  end

  # integration_tests: features/events_new requests/events_new
  def new
    @ev_types = current_team.event_types.to_a.map {|x| [x.name, x.acronym]}
    @ev_times = current_team.event_types.to_data.to_json
    @event    = params[:copy] ? EventForm.new.with_event(Event.find(params[:copy])) : EventForm.new
  end

  def create
    @event  = EventForm.new.submit(valid_params(params[:event]).merge({team_id: current_team.id}))
    if @event.valid? && @event.save
      redirect_to "/events/#{@event.event_ref}", notice: "Added #{@event.title}"
    else
      @ev_types = current_team.event_types.to_a.map {|x| [x.name, x.acronym]}
      render :new
    end
  end

  def destroy
    event = Event.find(params[:id])
    event.destroy
    redirect_to '/events'
  end

  private

  KEYS = %i(all_day description published start_date start_time finish_date finish_time location_name location_address typ team_id title leaders lat lon)

  def valid_params(params)
    params.permit(*KEYS)
  end
end
