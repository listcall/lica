# new_pgr

class Pgr::Send::Phone::Proxy::NoOp
  attr_reader :outbound

  def initialize(outbound = nil)
    @outbound = outbound
  end

  def opts_from(outbound = nil)
    'OK'
  end

  def default_opts
    {}
  end

  def deliver
    dev_log "SENDING FROM #{self.class.to_s} (outbound #{outbound.id})"
    'OK'
  end

end

