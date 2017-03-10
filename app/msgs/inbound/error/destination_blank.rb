class Inbound::Error::DestinationBlank

  attr_reader :inbound

  def initialize(inbound = nil)
    @inbound = inbound
  end

  def handle
    dev_log "#handle NOT IMPLEMENTED FOR #{self.class}", color: 'red'
  end
end