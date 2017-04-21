# new_pgr

require_relative '../util'

class Pgr::Send::Sms::Base

  extend Pgr::Send::Util

  def self.proxies
    {
      'development' => Pgr::Send::Sms::Proxy::SmsOpener   ,
      'dev_live'    => Pgr::Send::Sms::Proxy::Plivo       ,
      'production'  => Pgr::Send::Sms::Proxy::Plivo       ,
      'test'        => Pgr::Send::Sms::Proxy::NoOp
    }
  end

  def self.live_from_dev?(outbound)
    return false unless outbound.is_a? Pgr::Outbound::StiSms
    outbound.target_address == '16508230836'
  end
end