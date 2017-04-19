class PagerSingleAddressSvc

  include PagerUtil::Outboundable

  attr_reader   :pagers, :asnmts, :bcst
  attr_accessor :params

  def initialize(pager, input_params = {})
    @pagers = Array(pager)
    @pager  = pager
    @params = gen_bcst_params(input_params)
    @asnmts = nil
    @bcst   = nil
  end

  def create
    @params[:recipient_ids] = to_int(@params[:recipient_ids])
    @bcst   = Pgr::Broadcast.create(@params.except(:recipient_adr, :action, :channel_type, :channel_id))
    dev_log "CREATED BROADCAST #{@bcst.id}", @params.to_s
    dev_log "PAGERS", @pagers.first.assignments.first.attributes
    # @asnmts = @pagers.map { |pager| pager.assignments.create(pager_broadcast_id: @bcst.id) }
    # @asnmts = [@pager.assignments.create(pager_broadcast_id: @bcst.id)]
    @bcst.recipient_ids.each do |mem_id|
      mem = Membership.find_by_id(mem_id)
      next if mem.nil?
      next if mem.user.blank?
      next if mem.user.emails.blank?
      dev_log "CREATING POST - RECIP:#{mem.id}"
      target = @bcst.targets.create(recipient_id: mem.id)
      opts   = @bcst.initial_post_opts.merge(@params.slice(:action, :channel_type, :channel_id))
      post   = target.posts.create(opts)
      single_outbound_for(post, @params[:recipient_adr])
    end
    self
  end

  private

  def to_int(array)
    array.map {|x| x.to_i}
  end

  def gen_bcst_params(params)
    {
        sender_id:     params["sender_id"],
        # rsvp_id:       params["rsvp_id"],
        short_body:    params["short_body"],
        long_body:     params["long_body"],
        recipient_ids: params["recipient_ids"],
        recipient_adr: params["recipient_adr"],
        email:         "on",
        # xmpp:          "off",
        phone:         "off",
        # app:           "off",
        action:        params["action"],
        channel_type:  params["channel_type"],
        channel_id:    params["channel_id"]
    }
  end

end
