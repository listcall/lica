require 'ext/hash'

class Pgr::Util::GenFollowup

  attr_reader :assig, :dialog, :post, :outbounds

  def initialize(assig, followup, author_opts = {})
    @assig       = assig
    @followup    = followup
    @author_opts = author_opts
  end

  def generate_all
    generate_post
    generate_outbounds
    @dialog.mark_read_thread(@post.author)
    @post.set_action_value
    self
  end

  def deliver_all
    generate_all
    @outbounds.each { |out| out.deliver }
    self
  end

  private

  def generate_params(input)
    chan = input[:target_channels]
    input[:target_channels] = Array(chan) if chan
    input
  end

  def generate_post
    @post ||= get_post
  end

  def generate_outbounds
    @outbounds ||= get_outbounds
  end

  # ----- constructors ----

  def get_post
    rel = @dialog.posts
    rel.find_by(find_post_opts) || rel.create(post_opts)
  end

  def get_outbounds
    outb = []
    @dialog.posts.each do |post|
      # don't generate outbound for broadcast sender...
      next if post.author_id == @dialog.recipient_id && @dialog.recipient_id != @broadcast.sender_id
      post.target_channels.each do |channel|
        devices_for(post, channel).each do |device|
          opts = outbound_opts(post, channel, device)
          outb << post.outbounds.first_or_create(opts)
        end
      end
    end
    outb.uniq
  end

  # ----- post helpers -----

  def find_post_opts
    fields = %i(type author_id target_id short_body long_body)
    @find_opts ||= post_opts.slice(*fields)
  end

  def post_opts
    dev_log @params, color: 'blue'
    dev_log @params[:author_id], color: 'blue'
    base = {
      type:            'Pgr::Post::StiMsg',
      author_action:   'replied',
      target_id:       @dialog.other_participant_id(@params[:author_id]),
      target_channels: %i(email)
    }
    @gen_opts ||= base.merge(@params)
  end

  # ----- outbound helpers -----

  def devices_for(post, channel)
    return [] if post.target.blank?
    post.target.send("#{Pgr::Util::Channel.device_for(channel)}s").pagable
  end

  def outbound_opts(post, channel, device)
    {
      type:           "Pgr::Outbound::Sti#{channel.capitalize}",
      pgr_post_id:    post.id,
      target_id:      post.target_id,
      device_id:      device.id,
      device_type:    device.class.to_s,
      target_channel: channel,
      target_address: device.address,
      origin_address: 'NA'
    }
  end

end
