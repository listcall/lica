# new_pgr

require 'sms_opener/base'

class Pgr::Send::Sms::Proxy::SmsOpener
  attr_reader :outbound

  def initialize(outbound = nil)
    @outbound = outbound
    @opts     = opts_from(outbound)
  end

  def opts_from(outbound = nil)
    {
      to:     outbound.target_address ,
      fm:     (@address ||= outbound.get_origin_number),
      text:   outbound.text           ,
      fqdn:   outbound.fqdn
    }
  end

  def deliver
    SmsOpener::Service.new(@opts).deliver
    outbound.update_attributes(origin_address: (@address ||= outbound.get_origin_number), sent_at: Time.now)
  end
end
