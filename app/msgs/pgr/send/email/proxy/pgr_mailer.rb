# new_pgr

require_relative './action_mail_util'

class Pgr::Send::Email::Proxy::PgrMailer
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
    with_delivery_method(:opener_dm) do
      AcmPgr.for(outbound).deliver
    end
  end
end