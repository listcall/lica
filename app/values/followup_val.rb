class FollowupVal

  attr_reader :recipient_ids, :short_body, :channels

  def initialize(opts)
    @recipient_ids = opts["recipient_ids"] || []
    @short_body    = opts["short_body"]    || ""
    @channels      = opts["channels"]      || []
  end
end