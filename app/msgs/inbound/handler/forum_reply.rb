# new_pgr

class Inbound::Handler::ForumReply

  attr_reader :inbound

  def initialize(inbound = nil)
    @inbound = inbound
  end

  def handle
  end
end