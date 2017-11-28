class EventPeriodsController < ApplicationController

  before_action :authenticate_member!
  before_action :set_no_cache

  def index
    ctx = {user: current_user, env: request.env}
    @event  = Event.find_by(team_id: current_team.id, event_ref: params[:event_id]).decorate(context: ctx)
  end

  def show
    @event  = Event.find_by(team_id: current_team.id, event_ref: params[:event_id])
    @period = @event.periods.find_by(position: params[:id])
    @perbot = PeriodBot.new(current_membership, @period)
  end

  def new
    render plain: 'OK'
  end

  def create
    @event  = Event.find_by_event_ref(params[:event_id])
    period  = EventPeriodSvc.new(current_team, @event).create_period
    if period.valid?
      redirect_to "/events/#{@event.event_ref}", notice: "Added Period #{period.position}"
    else
      redirect_to "/events/#{@event.event_ref}", alert: 'There was an error creating the period...'
    end
  end

  def destroy
    @event  = Event.find_by_event_ref(params[:event_id])
    EventPeriodSvc.new(current_team, @event).destroy_period(params[:id])
    redirect_to "/events/#{@event.event_ref}", :notice => 'Period was deleted.'
  end

  def sort
    params['period'].each_with_index do |pid, idx|
      Event::Period.find(pid).update_attributes(position: idx+1)
    end
    render plain: 'OK'
  end

  private

  def valid_params(params)
    params.permit(:event_id)
  end

end
