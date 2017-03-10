# new_pgr

# require_relative "../util"

class Pgr::Send::Alarm::Proxy::Base

  # extend Pgr::Send::Alarm::Util

  PROXIES = {
    'development' => Pgr::Send::Alarm::Proxy::NoOp           ,
    'production'  => Pgr::Send::Alarm::Proxy::Pushover       ,
    'test'        => Pgr::Send::Alarm::Proxy::NoOp
  }
end