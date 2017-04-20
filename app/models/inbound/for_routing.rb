module Inbound::ForRouting
  def to_pager?
    self.destination.first.match(/^pager\@/) if has_destination?
  end

  def is_email?
    self.type == 'Inbound::StiEmail'
  end

  def is_sms?
    self.type == 'Inbound::StiSms'
  end

  def has_destination?
    self.destination.present?
  end

  def is_an_inbound?
    self.is_a?(Inbound)
  end
end