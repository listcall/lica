module PagerUtil
  module Outboundable

    private

    # problem: picking up recipients and users from different teams...
    def generate_outbounds_for(post, reply = false)
      recipient    = post.recipient
      devlog "STARTING INBOUND FOR RECIPIENT #{recipient.id}"
      return if recipient.nil?
      return if inbound_from_sms_or_email?(post) && sending_to_yourself?(post, recipient)
      generate_email_outbounds(post, recipient)
      generate_sms_outbounds(post, recipient)
      devlog "FINISH INBOUND FOR RECIPIENT #{recipient.id}"
    end

    def single_outbound_for(post, address)
      recipient = post.recipient
      return if recipient.nil?
      email = UserEmail.find_by_address(address)
      email.update_attribute(:pagable, true)
      send_page(PagerOutbound.create(email_id: email.id, recipient_id: recipient.id, type: "PagerOutboundEmail", pager_post_id: post.id))
    end

    def inbound_from_sms_or_email?(post)
      post.channel_type != "Web"
    end

    def sending_to_yourself?(post, recipient)
      recipient.user.id == Membership.find(post.creator_id).user.id
    end

    def generate_sms_outbounds(post, recipient)
      return unless post.broadcast.sms
      recipient.phones.pagable.to_a.each do |phone|
        devlog "CREATING OUTBOUND - RECIP: #{recipient.id} - PHONE: #{phone.id}"
        send_page(PagerOutbound.create(phone_id: phone.id, recipient_id: recipient.id, type: "PagerOutboundSms", pager_post_id: post.id))
      end
    end

    def generate_email_outbounds(post, recipient)
      return unless post.broadcast.email
      recipient.emails.pagable.to_a.each do |email|
        devlog "CREATING OUTBOUND - RECIP:#{recipient.id} - EMAIL: #{email.id}"
        send_page(PagerOutbound.create(email_id: email.id, recipient_id: recipient.id, type: "PagerOutboundEmail", pager_post_id: post.id))
      end
    end

    def send_page(outb)
      if Rails.env.production?
        PagerSenderWorker.perform_async(outb.id)
      else
        PagerSenderWorker.new.perform(outb.id)    # development
      end
    end

  end
end
