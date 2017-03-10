class TopicStatusSvc

  def initialize(membership_id, topic_id, status)
    @membership_id = membership_id
    @topic_id      = topic_id
    @status        = status
  end

  def update
    ActiveRecord::Base.transaction do
      topic = ForumTopic.find(@topic_id)
      return if topic.blank?
      topic.update_attributes(status: @status)
      ForumPost.create(team_id: topic.team_id, creator_id: @membership_id, action: "set status to #{@status}", forum_topic_id: @topic_id)
    end
  end

end
