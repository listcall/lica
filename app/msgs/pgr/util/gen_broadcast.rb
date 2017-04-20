# integration_test: requests/pgr/interaction

class Pgr::Util::GenBroadcast

  attr_reader :broadcast, :dialogs, :posts, :outbounds

  def initialize(bcst)
    @broadcast = bcst
  end

  def generate_all
    # TODO: generate in background
    generate_dialogs
    generate_posts
    generate_outbounds
    @broadcast.update_read_cache
    self
  end

  def deliver_all
    raise "Must first call 'generate_all'" if @outbounds.blank?
    # TODO: deliver in background
    @outbounds.each { |out| out.deliver }
    self
  end

  private

  def generate_dialogs
    @dialogs ||= begin
      @broadcast.recipient_ids.each do |mem_id|
        base = @broadcast.dialogs
        opts = {recipient_id: mem_id}
        base.find_by(opts) || base.create(opts)
      end
    end
  end

  def generate_posts
    @posts ||= begin
      @broadcast.dialogs.each do |dialog|
        opts = {
          type:            'Pgr::Post::StiMsg',
          author_action:   'posted',
          author_id:       @broadcast.sender_id,
          target_id:       dialog.recipient_id,
          author_channel:  'web',
          target_channels: @broadcast.outbound_channels,
          short_body:      @broadcast.short_body,
          long_body:       @broadcast.long_body
        }
        dialog.posts.first_or_create(opts)
      end
    end
  end

  def generate_outbounds
    @outbounds ||= begin
      outb = []
      @broadcast.posts.msgs.each do |post|
        post.target_channels.each do |channel|
          devices_for(post, channel).each do |device|
            opts = outbound_opts(post, channel, device)
            outb << (Pgr::Outbound.find_by(opts) || Pgr::Outbound.create(opts))
          end
        end
      end
      outb.uniq
    end
  end

  def devices_for(post, channel)
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
