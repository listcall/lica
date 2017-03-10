# new_pgr

class Inbound::Error::OriginEmailNonmember

  attr_reader :inbound

  def initialize(inbound = nil)
    @inbound = inbound
  end

  def handle
    AcmInboundError.origin_email_nonmember(inbound).deliver
  end
end