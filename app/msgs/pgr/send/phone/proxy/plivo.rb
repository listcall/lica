class Pgr::Send::Phone::Proxy::Plivo
  attr_reader :outbound

  def initialize(outbound = nil)
    @outbound = outbound
    @opts = opts_from(outbound) || default_opts
  end

  def opts_from(outbound = nil)
    return nil if outbound.nil?
    {
      'dst'  => outbound.target_address,
      'src'  => origin_adr,
      'text' => outbound.text,
      'type' => 'sms'
    }
  end

  def default_opts
    {}
  end

  def deliver
    # FIXME: check delivery status from PLIVO !!!
    client = Plivo::RestAPI.new(PLIVO_ID, PLIVO_TOKEN)
    dev_log 'PLIVO OUTBOUND'
    data_log @opts.to_s
    dev_log 'STARTING PLIVO SENDER'
    _response = client.send_message(@opts)
    dev_log 'SENT PLIVO MESSAGE'
    data_log _response, color: 'purple'
    outbound.update_attributes(origin_address: origin_adr, sent_at: Time.now)
  end

  private

  def origin_adr
    adr = outbound.get_origin_number
    dev_log "PLIVO ORIGIN OUTBOUND: #{adr}"
    adr
  end
end