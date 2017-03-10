class EventPeriodSvc

  def initialize(current_team, event)
    @current_team = current_team
    @event        = event
  end

  def create_period
    count = @event.periods.count
    Event::Period.create(event_id: @event.id, position: count + 1)
  end

  def destroy_period(id)
    period = @event.periods.where(position: id).to_a.first
    unless period.blank?
      period.destroy
      resort_periods
    end
  end

  def resort_periods
    @event.periods.sorted.each_with_index do |period, idx|
      dev_log "Position is #{idx}"
      period.update_attributes({position: idx+1})
    end
  end

end
