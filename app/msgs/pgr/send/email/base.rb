require_relative '../util'

class Pgr::Send::Email::Base

  extend Pgr::Send::Util

  class << self
    def proxies
      {
        'development' => Pgr::Send::Email::Proxy::PgrMailer      ,
        'dev_live'    => Pgr::Send::Email::Proxy::Mailgun        ,
        'production'  => Pgr::Send::Email::Proxy::Mailgun        ,
        'test'        => Pgr::Send::Email::Proxy::NoOp
      }
    end

    def live_from_dev?(outbound)
      return false unless outbound.is_a? Pgr::Outbound::StiEmail
      outbound.target_address == 'andy@r210.com'
    end
  end
end
