class Pgr::Action::StiOpRsvpHelpers::EmailHtml

  attr_reader :parent

  def initialize(parent)
    @parent = parent
    self
  end

  def footer(outbound)
    <<-EOF
      <p></p><b>RSVP: #{parent.query_msg}</b>
      <p></p>#{email_prompts(outbound)}
      <p></p>#{event_details(outbound)}
    EOF
  end

  private

  def email_prompts(outbound)
    parent.prompts.to_a.map do |prompt|
      url = "http://#{outbound.team_fqdn}/action/rsvp/#{outbound.id}/#{prompt.first}"
      lbl = "#{prompt.first.upcase} - #{prompt.last}"
      "<a href='#{url}'>#{lbl}</a>"
    end.join(" | ")
  end

  def event_details(outbound)
    "<hr>" +
    [event_period(outbound), event_location, page_log(outbound)].reject(&:blank?).join("<br/>")
  end

  def event_period(outbound)
    event  = parent.event
    period = parent.period
    team_fqdn = outbound.try(:team_fqdn)
    return "" if event.nil?
    <<-EOF
    #{event.try(:typ_name)}:
    <a href="http://#{team_fqdn}/events/#{event.try(:event_ref)}">#{event.try(:title)}</a>
    (OP#{period.try(:position)})
    EOF
  end

  def event_location
    event = parent.event
    name = event.try(:location_name)
    addr = event.try(:location_address)
    lat  = event.try(:lat)
    lon  = event.try(:lon)
    return "" if [name, addr].all?(&:nil?)
    name_str = [name, addr].join(" - ")
    return name_str if [lat, lon].any?(&:nil?)
    google_str = " (<a href='http://maps.google.com/?ll=#{lat},#{lon}'>Map</a>)"
    name_str + google_str
  end

  def page_log(outbound)
    target    = outbound.try(:target)
    dial_id   = outbound.try(:dialog).try(:id)
    assig_id  = parent.broadcast.try(:assignments).try(:first).try(:sequential_id)
    mem_name  = target.try(:user_name)
    team_fqdn = outbound.try(:team_fqdn)
    <<-EOF
      Pager Log:
      <a href="http://#{team_fqdn}/paging/#{assig_id}">team</a>
      |
      <a href="http://#{team_fqdn}/paging/#{assig_id}/for/#{dial_id}">@#{mem_name}</a>
    EOF
  end
end
