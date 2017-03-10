# new_pgr

class Inbound::Error::OriginEmailUnregistered

  attr_reader :inbound

  def initialize(inbound = nil)
    @inbound = inbound
  end

  def handle
    raise "NOT IMPLEMENTED: #{self.class}"
  end
end

__END__

Your address #{address} is not recognized by our system.

You can:
1) add #{address} to your user profile, then verify, or
2) ask your team owner to put #{address} on the address whitelist