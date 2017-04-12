class EventPeriodDecorator < Draper::Decorator
  delegate_all

  def period_cell
    x_klas = context[:parent_row] ? 'parentCell' : 'childCell'
    posn   = context[:parent_row] ? position : parent.try(:position)
    <<-ERB
      <span id="#{id}_#{position}" data-posn="#{posn}" class="periodCell #{x_klas}">
        #{period_label}#{start_label}
        <div class="participantCell">
          #{participant_widget(participants.count)}
          #{period_cell_delete(participants.count)}
        </div>
      </span>
    ERB
  end

  def start_date
    first_participant_start || prior_period_start
  end

  private

  def participant_widget(count)
    "<span style='color: black;' class='badge periodBadge'><i class='fa fa-group'></i> #{count}</span>"
  end

  def period_label
    return "P#{position} " if context[:parent_row]
    return '' if parent.blank?
    "P#{parent.position} "
  end

  def period_cell_delete(count)
    return '' if count != 0
    return '' if self.event.periods.count < 2
    "<i data-perid='#{self.id}' class='fa fa-times-circle perDel'></i>"
  end

  # ----- start date calculation and display -----

  def start_label
    start_date.try(:strftime, '%b%-d')
  end

  def first_participant_start
    participants.pluck(:departed_at, :signed_in_at).flatten.select{|x| x.present?}.min
  end

  def prior_period
    return 0 if position.nil?
    obj = event.periods.find_by_position(position - 1)
    return nil unless obj.present?
    EventPeriodDecorator.new(obj)
  end

  def prior_period_start
    return event.start if position.nil? || position < 2
    prior_period.try(:start_date).try(:+, 1.day)
  end

end
