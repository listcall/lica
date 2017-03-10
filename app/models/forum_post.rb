class ForumPost < ActiveRecord::Base

  # ----- Attributes -----
  store_accessor :xfields, :action
  store_accessor :xfields, :inbound_message_id

  # ----- Associations -----
  has_ancestry
  belongs_to :team
  belongs_to :forum_topic,     :touch      => true
  belongs_to :creator,         :class_name => 'Membership', :foreign_key => 'creator_id'
  has_many   :forum_outbounds, :dependent  => :destroy

  alias_method :topic,     :forum_topic
  alias_method :outbounds, :forum_outbounds

  # ----- Validations -----

  # ----- Callbacks -----
  before_create :ensure_uuid

  # ----- Scopes -----

  # ----- Class Methods ----

  # ----- Instance Methods -----
  def forum
    topic.forum
  end

  def ensure_uuid; self.uuid ||= SecureRandom.uuid end

  def message_id
    "<forum-#{id}@#{team.fqdn}>"
  end

  def email_headers
    base = {'Message-ID' => message_id}
    response = inbound_message_id.blank? ? {} : {'In-Response-To' => inbound_message_id}
    base.merge(response)
  end

end

# == Schema Information
#
# Table name: forum_posts
#
#  id             :integer          not null, primary key
#  ancestry       :string(255)
#  uuid           :uuid
#  team_id        :integer
#  forum_topic_id :integer
#  creator_id     :integer
#  body           :text
#  xfields        :hstore           default("")
#  votes          :text             default("{}"), is an Array
#  created_at     :datetime
#  updated_at     :datetime
#
