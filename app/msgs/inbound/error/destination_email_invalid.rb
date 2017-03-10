# new_pgr

class Inbound::Error::DestinationEmailInvalid

  attr_reader :inbound

  def initialize(inbound = nil)
    @inbound = inbound
  end

  def handle
    raise "NOT IMPLEMENTED: #{self.class}"
  end

end


__END__

Check for three destination email conditions:
1) Unrecognized (we don't have that in our system - do you mean...)
2) Ambiguous (multiple matches for an address)
3) Unpartnered (the email is in our system, but we are not partnerd)

Batch all the errors together into a single email.