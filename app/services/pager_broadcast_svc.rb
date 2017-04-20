class PagerBroadcastSvc

  include PagerUtil::Outboundable

  attr_reader   :pagers, :asnmts, :bcst
  attr_accessor :params

  def initialize(pager, input_params = {})
    @pagers = Array(pager)
    @params = gen_bcst_params(input_params)
    @asnmts = nil
    @bcst   = nil
  end

  def create
    @params[:recipient_ids] = to_int(@params[:recipient_ids])
    @bcst   = Pgr::Broadcast.create(@params.except(:action, :channel_type, :channel_id))
    dev_log "CREATED BROADCAST #{@bcst.id}", @params.to_s

    Pgr::Util::GenBroadcast.new(@bcst).generate_all.deliver_all

    self
  end

  private

  def to_int(array)
    array.map {|x| x.to_i}
  end

  def gen_bcst_params(params)
    {
        sender_id:     params["sender_id"],
        short_body:    params["short_body"],
        long_body:     params["long_body"],
        recipient_ids: params["recipient_ids"],
        email:         params["email"],
        sms:           params["sms"],
        action:        params["action"],
        channel_type:  params["channel_type"],
        channel_id:    params["channel_id"]
    }
  end

end
