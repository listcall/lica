# new_pgr

# require_relative "action_mail_util"

class Pgr::Send::Alarm::Proxy::NoOp
  # include ActionMailUtil

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
    dev_log 'SENDING FROM TST SENDER'
    'OK'
  end
end