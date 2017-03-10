load 'inbound/routes.rb'

class Inbound::Base
  attr_reader :inbound

  def initialize(inbound=nil)
    @inbound = inbound
  end

  def handler_class
    Inbound::RouteMap.handler_for(inbound)
  end

  def handle
    dev_log "HANDLER CLASS: #{handler_class.name}"
    handler_class.new(inbound).handle
  end
end