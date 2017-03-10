# new_pgr

require_relative 'action_mail_util'

class Pgr::Send::Email::Proxy::Mailgun
  include ActionMailUtil

  attr_reader :outbound

  def initialize(outbound = nil)
    @outbound = outbound
  end

  def opts_from(outbound = nil)
  end

  def default_opts
  end

  def deliver
    dev_log 'MAILGUN OUTBOUND'
    data_log outbound.attributes.to_s
    with_delivery_method(:mailgun_dm) do
      AcmPgr.for(outbound).deliver
    end
  end
end