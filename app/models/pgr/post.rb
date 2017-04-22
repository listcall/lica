require 'forwardable'

class Pgr::Post < ActiveRecord::Base

  extend Forwardable

  # ----- Attributes -----
  xfield_accessor :author_action, :author_channel,  :author_address
  xfield_accessor :target_address
  jfield_accessor :target_channels, default: [:web]

  # ----- Associations -----
  belongs_to :author,    class_name: 'Membership'   , foreign_key: 'author_id'
  belongs_to :target,    class_name: 'Membership'   , foreign_key: 'target_id'
  belongs_to :dialog,    class_name: 'Pgr::Dialog'  , foreign_key: 'pgr_dialog_id', touch:     true
  has_many   :outbounds, class_name: 'Pgr::Outbound', foreign_key: 'pgr_post_id'  , dependent: :destroy

  # ----- Scopes -----
  scope :for_dialog, -> { includes(:author => :user).where.not(id: nil) }
  scope :by_id     , -> { order(:id)                                    }
  scope :actions   , -> { where(type: 'Pgr::Post::StiAction')           }
  scope :msgs      , -> { where(type: 'Pgr::Post::StiMsg')              }

  # ----- Callbacks -----

  before_save :set_valid_target_channels

  def set_valid_target_channels
    target_channels = %w(web) if target_channels.blank?
    valid = %w(email sms web)
    raise 'INVALID TARGET CHANNEL' if (target_channels - valid).present?
  end

  # ----- Delegated Methods -----
  def_delegators :broadcast, :sender,    :sender_id
  def_delegators :dialog,    :recipient, :recipient_id, :num_posts

  # ----- Local Methods -----
  def headline
    name = author.try(:user_name)
    cmnt = author_action || 'commented'
    time = created_at.try(:strftime, '%H:%M')
    "#{name} #{cmnt} @ #{time}#{via}#{postid}"
  end

  def postid
    return "" unless Rails.env.development?
    " [#{self.id}]"
  end

  def parsed_body
    return '' if body.blank?
    result = EmailReplyParser.parse_reply(body)
    result
  end

  def via
    return '' if author_channel.nil?
    id = author_address.nil? ? '' : " (#{author_address})"
    " via #{author_channel}#{id}"
  end

  def reply_channels
    return nil if target_id.blank?
    PgrUtil::ChanList.new(dialog).reply_channels_for_target(target_id)
  end

  def reply_via
    item = reply_channels.try(:first)
    item ? " via #{item}" : ""
  end

  # def target_channels
  #   val = xfields["target_channels"]
  #   return [] if val.blank?
  #   eval(val.to_s)
  # end

  def broadcast; @broadcast ||= dialog.try(:broadcast); end
  def pgrs;      @pgrs      ||= broadcast.pgrs; end

  def body
    "#{short_body}\n#{long_body}"
  end

  def message_id
    "<pgr-#{dialog.id}-#{id}@#{recipient.team.fqdn}>"
  end

  def email_headers
    base = {'Message-ID' => message_id}
    # response = inbound_message_id.blank? ? {} : {"In-Response-To" => inbound_message_id}
    response = {}
    base.merge(response)
  end

  # ----- action response -----

  def action
    @action_var ||= dialog.try(:action)
  end

  def from_target?
    self.author_id = dialog.try(:recipient_id)
  end

  def action_value
    @action_val ||= action.class.action_for("#{self.short_body}" + "#{self.long_body}")
  end

  def set_action_response(val)
    self.action_response = val
    self.save
    dialog.try(:add_action_post, "answer was set to #{action_value}")
    dialog.try(:set_action_response, val)
  end

  def set_action_value
    return unless action && from_target? && action_value
    set_action_response(action_value)
  end

end

# == Schema Information
#
# Table name: pgr_posts
#
#  id              :integer          not null, primary key
#  type            :string
#  pgr_dialog_id   :integer
#  author_id       :integer
#  target_id       :integer
#  short_body      :text
#  long_body       :text
#  action_response :string
#  bounced         :boolean          default("false")
#  ignore_bounce   :boolean          default("false")
#  sent_at         :datetime
#  read_at         :datetime
#  xfields         :hstore           default("")
#  jfields         :jsonb            default("{}")
#  created_at      :datetime
#  updated_at      :datetime
#
