class EventDecorator < Draper::Decorator
  delegate_all

  def event_children_rows
    ctx = context
    children.map do |child_event|
      child_event.decorate(context: ctx).event_row
    end.join
  end

  def event_row(opts={})
    hdr = EventNavSvc.event_link(context[:user], self, context[:env])
    <<-ERB
    <tr class='#{opts[:row_klas]}'>
      <td style='vertical-align: middle; width: 1px; white-space: nowrap;'>#{hdr}</td>
      <td style='vertical-align: middle;'>#{period_cells(opts)}</td>
    </tr>
    ERB
  end

  private

  def period_cells(opts)
    idx = -1
    periods.map do |period|
      idx += 1
      <<-ERB
        <i data-eventid='#{self.id}' data-posn="#{idx}" class="fa fa-plus-circle perAdd"></i>
        #{EventPeriodDecorator.new(period, {context: opts}).period_cell}
      ERB
    end.join + "<i data-eventid='#{self.id}' data-posn='#{idx+1}' class='fa fa-plus-circle perAdd'></i>"
  end

end