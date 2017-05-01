class FollowupVal

  attr_reader :member_recipients, :short_body, :channels

  def initialize(opts)
    dev_log opts
    @member_recipients = opts["member_recipients"] || []
    @short_body        = opts["short_body"]        || ""
    @channels          = opts["channels"]          || []
  end

  def member_ids
    @member_recipients.to_a.select do |pair|
      pair.last == "on"
    end.map {|pair| pair.first}
  end

  def target_channels
    @channels.to_a.select do |pair|
      pair.last == "on"
    end.map {|pair| pair.first.to_sym}
  end
end
