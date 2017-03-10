class ForumTopicBookmark < ActiveRecord::Base

  # ----- Attributes -----

  # ----- Associations -----
  belongs_to :membership
  belongs_to :forum_topic
  belongs_to :forum
  belongs_to :team

  alias_method :topic, :forum_topic

  # ----- Validations -----

  # ----- Callbacks -----
  before_create :populate_forum_id

  # ----- Scopes -----

  # ----- Class Methods ----

  # ----- Instance Methods -----
  def populate_forum_id
    self[:forum_id] = topic.forum.id
  end

end

# == Schema Information
#
# Table name: forum_topic_bookmarks
#
#  id             :integer          not null, primary key
#  team_id        :integer
#  forum_id       :integer
#  forum_topic_id :integer
#  membership_id  :integer
#  read_at        :datetime
#  created_at     :datetime
#  updated_at     :datetime
#
