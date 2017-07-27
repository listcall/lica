class Ajax::EventsController < ApplicationController

  before_action :authenticate_reserve!

  respond_to :json

  def index
    respond_with current_team.events
  end

  def create
    @event  = EventForm.new.submit(valid_params(params).merge({team_id: current_team.id,
                                                               start_date: sdate(Time.now),
                                                               finish_date: sdate(Time.now + 3.day) }))
    @event.save if @event.valid?
    opts = [{:periods => :event}, {:team => :accepted_partners}]
    event = current_team.events.includes(opts).find_by(:event_ref => @event.event_ref)
    if event
      render json: event.periods.ids[0]
    else
      render :json => { :error => "err"},  :status => 422
    end
  end    

  def update
    dev_log 'STARTING UPDATE'
    data_log params
    field, value  = [params['name'], params['value']]
    select_vals = unless field.nil?
                    dev_log 'SINGLE ENTITY UPDATE'
                    {field => value}
                  else
                    dev_log 'MULTI ENTITY UPDATE'
                    params.to_unsafe_h['event']
                  end
    ar_event      = current_team.events.find(params[:id])
    ef_event      = EventForm.new.with_event(ar_event).update(select_vals)
    if ef_event.valid? && ef_event.save
      dev_log 'UPDATE WAS SUCCESSFUL'
      render plain: ef_event.event_ref
    else
      dev_log 'UPDATE WAS NOT SUCCESSFUL'
      ef_event.event.errors.messages.keys.each { |key| ef_event.errors.add key, ef_event.errors[key].first}
      dev_log 'ERRORS:', validation_message(ef_event)
      render plain: validation_message(ef_event), status: 400
    end
  end

  def tag_uniq
    render json: current_team.events.tag_uniq
  end

  private

  KEYS = %i(all_day description published start_date start_time finish_date finish_time location_name location_address typ team_id title leaders lat lon)

  def valid_params(params)
    params.permit(*KEYS)
  end

  def sdate(time)
    time.strftime('%Y-%m-%d')
  end

  def validation_message(obj)
    count = obj.errors.count
    return 'Invalid data - please try again.' if count == 0
    obj.errors.full_messages.map.with_index {|msg, i| "#{msg}"}.join(', ')
  end

end
