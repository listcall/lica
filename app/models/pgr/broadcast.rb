require 'app_ext/pkg'

class Pgr::Broadcast < ActiveRecord::Base

  PAGER_CHANNELS = %i(email phone)

  # ----- Associations -----
  belongs_to :sender,  :class_name => 'Membership', :foreign_key => :sender_id
  with_options :dependent => :destroy do
    has_many :assignments , :class_name => 'Pgr::Assignment', :foreign_key => :pgr_broadcast_id
    has_many :dialogs     , :class_name => 'Pgr::Dialog'    , :foreign_key => :pgr_broadcast_id
    has_one  :action      , :class_name => 'Pgr::Action'    , :foreign_key => :pgr_broadcast_id
  end

  has_many   :pgrs    , :through   => :assignments
  has_many   :posts   , :through   => :dialogs

  # ----- Callbacks -----
  before_create :set_deliver_at

  # ----- Attributes -----
  xfield_accessor :sender_channel, :sender_note
  xfield_flags    *PAGER_CHANNELS
  jfield_accessor :red_mems, :clear_mems, :read_first, default: []

  # ----- for unread messages icon -----
  def update_read_cache
    # use `dialogs(true)` to force reloading the relationship
    self.read_first = dialogs.includes(:broadcast.try(:id).try(:id)).map do |dialog|
      dialog.first_read_by
    end.reduce(:|).sort
    self.red_mems = dialogs.map do |dialog|
      dialog.target_mems_with_unread_posts
    end.reduce(:|).sort
    self.clear_mems = dialogs.map do |dialog|
      dialog.mems_who_read_all_posts(read_first)
    end.reduce(:&)
    save
  end

  # unread messages addressed to member
  def is_red?(mem)
    red_mems.include? mem.to_i
  end

  # unread messages addressed to another member
  def is_clear?(mem)
    clear_mems.include? mem.to_i
  end

  def comment_icon_for(member)
    member_id = member.to_i
    return '' if is_clear?(member_id)
    highlight  = is_red?(member_id) ? 'red' : ''
    comment    = is_red?(member_id) ? ' addressed to you' : ''
    title      = "unread posts#{comment}"
    "<i class='fa fa-comments #{highlight} postRef' title='#{title}'/>"
  end

  # ----- misc helpers -----
  def read_count
    dialogs.where('recipient_read_at IS NOT NULL').count
  end

  def dialog_for(member)
    dialogs.find_by(recipient_id: member.to_i)
  end

  def pager_channels
    PAGER_CHANNELS
  end

  def outbound_channels
    pager_channels.select {|chan| self.send(chan) }
  end

  def set_deliver_at
    self[:deliver_at] ||= Time.now
  end

  def team
    sender.try(:team)
  end
end

# == Schema Information
#
# Table name: pgr_broadcasts
#
#  id            :integer          not null, primary key
#  sender_id     :integer
#  short_body    :text
#  long_body     :text
#  deliver_at    :datetime
#  recipient_ids :integer          default("{}"), is an Array
#  xfields       :hstore           default("")
#  jfields       :jsonb            default("{}")
#  created_at    :datetime
#  updated_at    :datetime
#
