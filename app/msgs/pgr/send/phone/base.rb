# new_pgr

require_relative '../util'

class Pgr::Send::Phone::Base

  extend Pgr::Send::Util

  def self.proxies
    {
      'development' => Pgr::Send::Phone::Proxy::SmsOpener   ,
      'dev_live'    => Pgr::Send::Phone::Proxy::Plivo       ,
      'production'  => Pgr::Send::Phone::Proxy::Plivo       ,
      'test'        => Pgr::Send::Phone::Proxy::NoOp
    }
  end

  def self.live_from_dev?(outbound)
    return false unless outbound.is_a? Pgr::Outbound::StiPhone
    outbound.target_address == '16508230836'
  end
end