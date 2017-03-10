# new_pgr

require_relative 'action_mail_util'

class Pgr::Send::Email::Proxy::NoOp
  include ActionMailUtil

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
    with_delivery_method(:noop_dm) do
      AcmPgr.for(outbound).deliver
    end
    'OK'
  end
end