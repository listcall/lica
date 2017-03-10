class Event::AsPgrAssignmentNew < Event
  class << self
    def period_list(ev_input)
      (start, fini) = [Time.now - 1.month, Time.now + 2.months]
      events = ev_input.includes(:periods).between(start, fini)
      dev_log events.count
      result = events.map do |event|
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
      dev_log result.length
      result
    end
  end
end

# == Schema Information
#
# Table name: events
#
#  id                       :integer          not null, primary key
#  event_ref                :string(255)
#  team_id                  :integer
#  typ                      :string(255)
#  title                    :string(255)
#  leaders                  :string(255)
#  description              :text
#  location_name            :string(255)
#  location_address         :string(255)
#  lat                      :decimal(7, 4)
#  lon                      :decimal(7, 4)
#  start                    :datetime
#  finish                   :datetime
#  all_day                  :boolean          default("true")
#  published                :boolean          default("false")
#  xfields                  :hstore           default("")
#  external_id              :string(255)
#  signature                :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#  ancestry                 :string(255)
#  event_periods_count      :integer          default("0"), not null
#  event_participants_count :integer          default("0"), not null
#  tags                     :text             default("{}"), is an Array
#
