class Ajax::EventsController < ApplicationController

  before_action :authenticate_member!

  respond_to :json

  def index
    respond_with current_team.events
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

  def validation_message(obj)
    count = obj.errors.count
    return 'Invalid data - please try again.' if count == 0
    obj.errors.full_messages.map.with_index {|msg, i| "#{msg}"}.join(', ')
  end

end
