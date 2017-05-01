# integration_test: requests/pgr/followup

require 'ext/hash'

class Pgr::Util::GenFollowup

  attr_reader :assig, :followup

  def initialize(assig, followup)
    @assig    = assig
    @followup = followup
  end

  def generate_all
    generate_posts
    generate_outbounds
    # @dialog.mark_read_thread(@post.author)
    # @post.set_action_value
    self
  end

  def deliver_all
    generate_all
    dev_log @outbounds.first.class
    @outbounds.each { |out| out.deliver }
    self
  end

  private

  def generate_params(input)
    chan = input[:target_channels]
    input[:target_channels] = Array(chan) if chan
    input
  end

  def generate_posts
    @posts ||= begin
      dialogs.map do |dialog|
        post_params = {
          type:            'Pgr::Post::StiMsg',
          author_id:       dialog.broadcast.sender_id,
          target_id:       dialog.recipient_id,
          short_body:      @followup.short_body,
          long_body:       ""
        }
        post = dialog.posts.find_by(post_params) || dialog.posts.create(post_params)
        post.author_action   = "followed up"
        post.author_channel  = "web"
        post.target_channels = @followup.target_channels
        post.save
        post
      end
    end
  end

  def generate_outbounds
    @outbounds ||= begin
      outb = []
      @posts.each do |post|
        # don't generate outbound for broadcast sender...
        next if post.author_id == post.dialog.recipient_id && post.dialog.recipient_id != broadcast.sender_id
        post.target_channels.each do |channel|
          devices_for(post, channel).each do |device|
            opts = outbound_params(post, channel, device)
            dev_log post
            dev_log channel
            dev_log device
            dev_log opts.inspect
            dev_log Pgr::Outbound.count
            outb << (post.outbounds.find_by(opts) || post.outbounds.create(opts))
          end
        end
      end
      outb.uniq                  #
    end
  end

  # ----- constructors ----

  def broadcast
    @assig.broadcast
  end

  def recipient_ids
    @recipient_ids ||= @followup.member_ids
  end

  def dialogs
    @dialogs ||= broadcast.dialogs.where(recipient_id: recipient_ids)
  end

  # ----- outbound helpers -----

  def devices_for(post, channel)
    return [] if post.target.blank?
    post.target.send("#{Pgr::Util::Channel.device_for(channel)}s").pagable
  end

  def outbound_params(post, channel, device)
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
