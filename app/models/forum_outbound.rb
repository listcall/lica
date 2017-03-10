require 'forwardable'

class ForumOutbound < ActiveRecord::Base

  extend Forwardable

  # ----- associations -----
  belongs_to :forum_post
  belongs_to :recipient, :class_name => 'Membership'

  alias_method :post, :forum_post

  # ----- delegated methods -----
  def_delegators :post, :creator, :topic

  # ----- callbacks -----
  before_create :set_default_type

  # ----- scopes -----
  scope :pending, -> { where('sent_at is NULL') }
  scope :sent,    -> { where('sent_at is not NULL') }

  # ----- local methods -----
  #def topic; @topic ||= post.topic ;  end
  def forum; @forum ||= topic.forum;  end
  def team;  @team  ||= forum.team ;  end

  def set_default_type; self[:type] ||= 'ForumOutboundEmail';  end

  # ----- local methods for message data -----
  def msg_to        ;  [] end
  def msg_from_name ;  '' end
  def msg_from_email;  '' end
  def msg_subject   ;  '' end
  def msg_text      ;  '' end
  def msg_html      ;  '' end
  def msg_headers   ;  {} end
  def msg_alt       ;  {} end

end

# == Schema Information
#
# Table name: forum_outbounds
#
#  id            :integer          not null, primary key
#  forum_post_id :integer
#  recipient_id  :integer
#  type          :string(255)
#  bounced       :boolean          default("false")
#  xfields       :hstore           default("")
#  read_at       :datetime
#  sent_at       :datetime
#  created_at    :datetime
#  updated_at    :datetime
#
