class ForumBroadcastSvc

  def self.deliver(post)
    topic = post.topic
    forum = topic.forum
    topic_subscribers = topic.topic_subscriptions.to_a
    forum_subscribers = forum.forum_subscriptions.to_a
    subscriber_list   = (topic_subscribers + forum_subscribers).map {|sub| sub.membership_id}.uniq
    subscriber_list.each do |mem_id|
      outb = ForumOutbound.create recipient_id: mem_id, forum_post_id: post.id
      if Rails.env.production?
        ForumSenderWorker.perform_async(outb.id)
      else
        ForumSenderWorker.new.perform(outb.id)
      end
    end
    'OK'
  end

end