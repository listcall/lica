require 'forwardable'
require 'time'
require 'app_ext/pkg'

class Pgr::Dialog < ActiveRecord::Base

  extend Forwardable

  STD = '%Y-%m-%d %H:%M:%S'

  # ----- Attributes Fields -----
  jfield_accessor  :first_post_at
  jfield_accessor  :first_read_by, default: []
  jfield_accessor  :last_post_at
  jnested_accessor :last_read_by

  # ----- Associations -----
  belongs_to :recipient, :class_name => 'Membership',     :foreign_key => :recipient_id
  belongs_to :broadcast, :class_name => 'Pgr::Broadcast', :foreign_key => :pgr_broadcast_id, :inverse_of => :dialogs
  has_many   :posts,     :class_name => 'Pgr::Post'     , :foreign_key => :pgr_dialog_id ,   :dependent  => :destroy
  has_many   :inbounds,  :class_name => 'Inbound'       , :foreign_key => :pgr_dialog_id ,   :dependent  => :destroy
  has_many   :outbounds, :through => :posts

  alias_method :receiver, :recipient

  # ----- Delegated Methods -----
  def_delegators :broadcast, :sender_id, :sender, :short_body, :action

  # ----- for unread messages icon -----
  def comment_icon_for(member)
    member_id = member.to_i
    return '' if is_clear?(member_id)
    highlight       = is_red?(member_id) ? 'red' : ''
    comment         = is_red?(member_id) ? ' addressed to you' : ''
    title           = "unread posts#{comment}"
    "<i class='fa fa-comments #{highlight} postRef' title='#{title}'/>"
  end

  def is_red?(member_id)
    @red_val ||= target_mems_with_unread_posts.include? member_id
  end

  def is_clear?(member_id)
    @dialog_first ||= broadcast.read_first
    @all_read     ||= mems_who_read_all_posts(@dialog_first)
    @all_read.include? member_id
  end

  # ----- action recording -----
  def mark_posted(member = nil)
    mem_id  = member.to_i
    mem_id  = broadcast.sender_id.to_i if mem_id == 0
    ctime = Time.now
    self.first_post_at    ||= ctime.strftime(STD)
    self.last_post_at     =   ctime.strftime(STD)
    self.set_first_read(mem_id)
    self.set_last_read_by alt_id(mem_id), (ctime - 1.second).strftime(STD)
    self.set_last_read_by mem_id        , (ctime + 1.second).strftime(STD)
    self.save
  end

  def mark_read_thread(member)
    self.reload
    member_id = member.to_i
    check_for_first_read_by(member_id)
    set_last_read_by member_id.to_s, (Time.now + 1.second).strftime(STD)
    set_first_read(member_id)
    self.save
    broadcast.try(:update_read_cache)
  end

  def check_for_first_read_by(member_id)
    return unless first_recipient_read?(member_id)
    add_first_read_post
    self.recipient_read_at = Time.now.strftime(STD)
  end

  def set_first_read(member_id)
    self.first_read_by = (self.first_read_by | [member_id]).sort
  end

  # ----- data gathering and summarizing -----
  def target_mems_with_unread_posts
    last_read_by.to_a.select do |ele|
      next false unless is_in_dialog?(ele[0])
      next true  if     last_post_at.blank?
      ele[1] <= last_post_at
    end.map {|ele| ele[0].to_i}
  end

  def mems_who_read_all_posts(broadcast_first_reads = [])
    self.reload if jfields.blank?
    time = self.first_post_at || Time.now.strftime(STD)
    time_stamp = (Time.parse(time) + 1.second).strftime(STD)
    bcst_hash  = broadcast_first_reads.reduce({}) do |acc, v|
      acc[v.to_s] = time_stamp; acc
    end
    merged_reads = bcst_hash.merge(last_read_by)
    merged_reads.to_a.select do |ele|
      next true if last_post_at.blank?
      ele[1] > last_post_at
    end.map {|ele| ele[0].to_i}
  end

  # ----- other instance methods -----
  def alt_id(id)
    (participant_ids - [id]).first
  end

  def add_first_read_post
    add_action_post('Recipient read message')
  end

  def add_action_post(message)
    Pgr::Post::StiAction.create(pgr_dialog_id: self.id, short_body: message)
  end

  def first_recipient_read?(member)
    is_recipient?(member) && recipient_read_at.blank?
  end

  def is_recipient?(member)
    member.to_i == recipient_id
  end

  def participant_ids
    [sender_id, recipient_id]
  end

  def participants
    [sender, recipient]
  end

  def is_in_dialog?(member)
    participant_ids.include?(member.to_i)
  end

  def set_action_response(val)
    action.change_state(self.recipient_id, val)
    self.action_response = val
    self.save
  end

  def num_posts() posts.where(type: 'Pgr::Post::StiMsg').count; end
end

# == Schema Information
#
# Table name: pgr_dialogs
#
#  id                       :integer          not null, primary key
#  pgr_broadcast_id         :integer
#  recipient_id             :integer
#  recipient_read_at        :datetime
#  unauth_action_token      :string
#  unauth_action_expires_at :datetime
#  action_response          :string
#  xfields                  :hstore           default({})
#  jfields                  :jsonb
#  created_at               :datetime
#  updated_at               :datetime
#
