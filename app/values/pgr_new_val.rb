class PgrNewVal

  attr_reader :action_type, :action_opid

  def initialize(params)
    @action_type = params["pg_action"]
    @action_opid = params["pg_opid"]
    dev_log "NEW", params.to_unsafe_h, @action_type, @action_opid
  end

  def generate_new_params
    {
      "action_type" => @action_type,
      "action_opid" => @action_opid.to_i,
      "recip_ids"   => recip_ids   ,
      "short_text"  => default_msg
    }
  end

  private

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

  def participant_ids
    period.participants.map {|participant| participant.membership.id}
  end

  def recip_ids
    case @action_type
      when "RSVP"   then "ALL"
      when "NOTIFY" then participant_ids
      else []
    end
  end

  def default_msg
    case @action_type
      when "RSVP"   then "IMMEDIATE CALLOUT: #{event_title}/OP#{period_num} "
      when "NOTIFY" then "TEAM NOTIFICATION: #{event_title}/OP#{period_num} "
      else "#{event_title}/OP#{sid} "
    end
  end
end
