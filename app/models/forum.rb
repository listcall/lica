require 'app_ext/pkg'
require 'app_auth/methods'

class Forum < ActiveRecord::Base

  include AppAuth::Methods

  acts_as_list :scope => :team_id

  # ----- Attributes -----

  xfields_accessor :v_rights, :v_roles, :p_rights, :p_roles

  # ----- Associations -----
  belongs_to :team
  has_many   :forum_topics,              :dependent => :destroy
  has_many   :forum_topic_bookmarks,     :dependent => :destroy
  has_many   :forum_subscriptions,       :dependent => :destroy

  alias_method :topics,          :forum_topics
  alias_method :topic_bookmarks, :forum_topic_bookmarks
  alias_method :subscriptions,   :forum_subscriptions

  # ----- Validations -----
  validates_inclusion_of :type, in: %w(FmDiscussion FmIssue FmQuestion FmComment)

  # ----- Callbacks -----
  before_validation :name_snake
  before_validation :set_default_type

  # ----- Scopes -----
  scope :sorted, -> { order('position ASC')}

  # ----- Class Methods ----
  def self.by_name(name)
    Forum.where('name ILIKE ?', name.gsub('_', ' '))
  end

  # ----- Instance Methods -----
  def set_default_type
    self.type ||= 'FmDiscussion'
  end

  def name_snake
    return if self[:name].blank?
    require 'ext/string'
    self[:name] = self[:name].to_snake
  end

  def unread_topics_for(membership)
    marks = topic_bookmarks.where(membership_id: membership.id)
    bhash = marks.to_a.reduce({}) {|acc, val| acc[val.forum_topic_id] = val.read_at ; acc}
    topics.select {|topic| bhash[topic.id].nil? || topic.updated_at > bhash[topic.id]}
  end

  def display_type
    type.gsub('Fm', '') + 's'
  end

  def email_name
    name.downcase.gsub(' ', '_')
  end

  def email_base
    ''
  end

  def email_address
    "#{email_name}-#{display_type.downcase}@#{team.fqdn}"
  end

  def to_param
    self.name.downcase.gsub(' ', '_')
  end

end

# == Schema Information
#
# Table name: forums
#
#  id             :integer          not null, primary key
#  type           :string(255)
#  team_id        :integer
#  primary_id     :integer
#  primary_type   :integer
#  name           :string(255)
#  position       :integer
#  topic_sequence :integer
#  xfields        :hstore           default("")
#  tags           :text             default("{}"), is an Array
#  created_at     :datetime
#  updated_at     :datetime
#
