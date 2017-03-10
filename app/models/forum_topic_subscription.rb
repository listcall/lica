class ForumTopicSubscription < ActiveRecord::Base

  # ----- Attributes -----

  # ----- Associations -----
  belongs_to :membership
  belongs_to :topic

  # ----- Validations -----

  # ----- Callbacks -----

  # ----- Scopes -----

  # ----- Class Methods ----

  # ----- Instance Methods -----
  def forum_id
    topic.forum.id
  end

  def forum
    topic.forum
  end

end

# == Schema Information
#
# Table name: forum_topic_subscriptions
#
#  id             :integer          not null, primary key
#  team_id        :integer
#  forum_topic_id :integer
#  membership_id  :integer
#  created_at     :datetime
#  updated_at     :datetime
#
