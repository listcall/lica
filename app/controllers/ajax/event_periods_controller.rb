class Ajax::EventPeriodsController < ApplicationController

  before_action :authenticate_reserve!

  respond_to :json, :html

  def create
    Event::Period.create(event_id: params['tgt_event_id'], position: params['position'])
    reposition_periods(Event.find(params['tgt_event_id']))
    render plain: 'OK'
  end

  def update
    child_id  = params['child_id']
    parent_id = params['child']['parent_id']
    child_period  = Event::Period.find(child_id)
    parent_period = parent_id.present? && Event::Period.find(parent_id)
    child_period.parent = parent_period || nil
    child_period.try(:save)
    parent_period.try(:save)
    obj = EventPeriodDecorator.new(child_period)
    render plain: obj.period_cell
  end

  def destroy
    eperi = Event::Period.find(params['id'])
    event = eperi.event
    eperi.destroy
    event.reload
    reposition_periods(event)
    render plain: 'OK'
  end

  private

  def reposition_periods(event)
    event.periods.sorted.each_with_index do |period, idx|
      period.update_attributes(position: idx+1)
    end
  end

  def valid_params(params)
    params.permit :parent_id
  end

end
