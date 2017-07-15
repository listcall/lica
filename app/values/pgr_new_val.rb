class PgrNewVal

  attr_reader :action_type, :action_opid

  def initialize(params)
    @action_type = params["pg_action"]
    @action_opid = params["pg_opid"]
  end

  def generate_new_params
    {
      "overview" => overview_text,
      "base" => {
        "action_type" => @action_type,
        "action_opid" => @action_opid.to_i,
        "recip_ids"   => recip_ids   ,
        "short_text"  => default_msg
      }
    }
  end

  private

  def team_name
    period.event.team.acronym
  end

  def period
    @period ||= Event::Period.find(@action_opid.to_i)
  end

  def has_period?
    period.present?
  end

  def period_num
    period.try(:position) || 0
  end

  def event_title
    period.try(:event).try(:title) || ""
  end

  def event_path
    ref = period.try(:event).try(:event_ref)
    "/events/#{ref}"
  end

  def period_path
    "#{event_path}/periods/#{period_num}"
  end

  def participant_ids
    period.participants.map {|participant| participant.membership.id}
  end

  def pending_leave_participant_ids
    period.participants.has_not_left.map {|participant| participant.membership.id}
  end

  def pending_return_participant_ids
    period.participants.has_not_returned.map {|participant| participant.membership.id}
  end

  def recip_ids
    case @action_type
      when "RSVP"   then "ALL"
      when "NOTIFY" then participant_ids
      when "LEAVE"  then pending_leave_participant_ids
      when "RETURN" then pending_return_participant_ids
      else []
    end
  end

  def default_msg
    case @action_type
      when "HEADS_UP"   then "HEADS UP: #{event_title}/OP#{period_num} Would you be available?"
      when "IMMEDIATE_CALLOUT"   then "IMMEDIATE CALLOUT: #{event_title}/OP#{period_num} "
      when "DELAYED_CALLOUT"   then "DELAYED CALLOUT: #{event_title}/OP#{period_num} "
      when "NOTIFY" then "TEAM NOTIFICATION: #{event_title}/OP#{period_num} "
      when "LEAVE"  then "#{event_title}/OP#{period_num}: Have you left home? "
      when "RETURN" then "#{event_title}/OP#{period_num}: Have you returned home? "
      else "#{event_title}/OP#{sid} "  #FIXME: Is side defined?
    end
  end

  def overview_text
    case @action_type
      when "HEADS_UP"   then "This invite is addressed to all #{team_name} team members.#{period_links}"
      when "IMMEDIATE_CALLOUT"   then "This invite is addressed to all #{team_name} team members.#{period_links}"
      when "DELAYED_CALLOUT"   then "This invite is addressed to all #{team_name} team members.#{period_links}"
      when "NOTIFY" then "This notification is addressed to all event participants.#{period_links}"
      when "LEAVE"  then "This 'Left Home' message is addressed to all pending participants.#{period_links}"
      when "RETURN" then "This 'Return Home' message is addressed to all pending participants.#{period_links}"
      else "#{event_title}/OP#{sid} "  #FIXME: Is side defined?
    end
  end

  def period_links
    ev_link = "<a href='#{event_path}' target='_blank'>#{event_title}</a>"
    pd_link = "<a href='#{period_path}' target='_blank'>OP#{period_num}</a>"
    " #{ev_link} | #{pd_link}"
  end
end
