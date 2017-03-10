class ForumTopic < ActiveRecord::Base

  # ----- Attributes -----
  attr_accessor :initial_post

  # ----- Associations -----
  belongs_to :forum,                     :touch     => true
  has_many   :forum_posts,               :dependent => :destroy
  has_many   :forum_topic_subscriptions, :dependent => :destroy
  has_many   :forum_topic_bookmarks,     :dependent => :destroy
  belongs_to :creator,  :class_name => 'Membership', :foreign_key => 'creator_id'
  belongs_to :assignee, :class_name => 'Membership', :foreign_key => 'assignee_id'

  alias_method :posts,               :forum_posts
  alias_method :topic_subscriptions, :forum_topic_subscriptions
  alias_method :topic_bookmarks,     :forum_topic_bookmarks

  # ----- Validations -----

  # ----- Callbacks -----
  before_create :set_default_status
  before_create :populate_scoped_id
  before_create :populate_type

  # ----- Scopes -----

  # ----- Class Methods ----

  # ----- Instance Methods -----
  def set_default_status
    self[:status] = 'Open'
  end

  def populate_scoped_id
    forum.increment! :topic_sequence
    self[:scoped_id] = forum.topic_sequence
  end

  def populate_type
    self[:type] ||= forum.type.try(:gsub, 'Fm', 'Tp')
  end

  def to_param
    self.scoped_id.to_s
  end

  def unread_posts_for(membership)
    bmark = topic_bookmarks.where(membership_id: membership.id).to_a.first
    return posts if bmark.nil?
    posts.where('created_at > ?', bmark.read_at).to_a
  end

end

# == Schema Information
#
# Table name: forum_topics
#
#  id          :integer          not null, primary key
#  scoped_id   :integer
#  type        :string(255)
#  team_id     :integer
#  forum_id    :integer
#  title       :string(255)
#  creator_id  :integer
#  assignee_id :integer
#  status      :string(255)
#  xfields     :hstore           default("")
#  tags        :text             default("{}"), is an Array
#  created_at  :datetime
#  updated_at  :datetime
#
