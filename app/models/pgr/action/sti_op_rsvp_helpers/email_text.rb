class Pgr::Action::StiOpRsvpHelpers::EmailText

  attr_reader :parent

  def initialize(parent)
    @parent = parent
    self
  end

  def footer(outbound)
    <<-EOF.gsub("    ","").strip
    #{divider}
    RSVP: #{parent.query_msg}
    #{email_prompts(outbound)}
    #{event_details(outbound)}
    #{divider}
    EOF
  end

  private

  def email_prompts(outbound)
    parent.prompts.to_a.map do |prompt|
      url = "http://#{outbound.team_fqdn}/action/rsvp/#{outbound.id}/#{prompt.first}"
      lbl = "#{prompt.first.upcase.rjust(4)}"
      "#{lbl}: #{prompt.last} (#{url})"
    end.join("\n")
  end

  def event_details(outbound)
    divider + "\n" +
        [event_period(outbound), event_location, page_log(outbound)].reject(&:blank?).join("\n")
  end

  def event_period(outbound)
    event  = parent.event
    return "" if event.nil?
    period = parent.period
    team_fqdn  = outbound.try(:team_fqdn)
    event_path = "http://#{team_fqdn}/events/#{event.try(:event_ref)}"
    "#{event.try(:typ_name)} (OP#{period.try(:position)}): #{event.try(:title)} (#{event_path})"
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
    geo_str = " (#{lat},#{lon})"
    name_str + geo_str
  end

  def page_log(outbound)
    assig_id  = parent.broadcast.try(:assignments).try(:first).try(:sequential_id)
    team_fqdn = outbound.try(:team_fqdn)
    team_url  = "http://#{team_fqdn}/paging/#{assig_id})"
    "Pager Log: #{team_url}"
  end
  
  def divider
    "-------------------------"
  end
end
