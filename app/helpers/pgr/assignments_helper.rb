module Pgr::AssignmentsHelper
  def period_list(ev_input)
    (start, fini) = [Time.now - 1.month, Time.now + 2.months]
    events = ev_input.includes(:periods).between(start, fini)
    events.map do |event|
      period_hash = event.periods.map do |period|
        {
          period_id: period.id,
          label:     "OP#{period.position}"
        }
      end
      {
        event_id:    event.id,
        type_short:  event.typ,
        type_long:   'TBD',
        title_short: event.title[0..25],
        title_long:  event.title,
        start:       event.start.strftime('%b %d'),
        periods:     period_hash
      }
    end
  end

end