class Event::Participant < ActiveRecord::Base

  extend Forwardable

  # ----- Attributes -----

  def_delegators :member, :user_name, :full_name, :avatar
  def_delegators :period, :event

  # ----- Associations -----
  belongs_to   :period     , :touch => true, :foreign_key => 'event_period_id', :class_name => 'Event::Period'
  belongs_to   :membership , :touch => true

  alias_method :member, :membership

  counter_culture [:period, :event], column_name: 'event_participants_count'

  # ----- Callbacks -----

  before_save    :check_transit_times
  before_save    :check_signin_times
  # after_create   :instrument_create
  # before_destroy :instrument_destroy

  # ----- Validations -----

  validates_presence_of :event_period_id
  # validates_presence_of :event_period

  # ----- Scopes -----

  # see http://railscasts.com/episodes/215-advanced-queries-in-rails-3
  # aka 'non-guests'...
  scope :registered, -> { joins(:member).merge(Member.registered) }

  scope :has_not_left, ->     { where('departed_at is NULL')             }
  scope :has_left    , ->     { where('departed_at is not NULL')         }
  scope :is_departed , ->     { has_left.where('returned_at is NULL')    }
  scope :has_returned, ->     { where('returned_at is not NULL')         }
  scope :sans_period , ->     { where('event_period_id is NULL')         }
  scope :by_mem_id   , ->(id) { where(membership_id: id)                 }

  def self.by_event_title(title)
    joins(:period => :event).where('events.title ILIKE ?', title)
  end

  def self.by_event_type(type)
    joins(:period => :event).where('events.typ' => Array(type))
  end

  def self.by_event_tag(tags)
    joins(:period => :event).where('events.tags @> ARRAY[?]', Array(tags))
  end

  def self.after_date(date)
    joins(:period => :event).where('events.start > ?', date)
  end

  def self.order_by_name
    joins(:membership => :user).order('users.last_name ASC')
  end

  def self.ordered
    joins(:period => :event).order('events.start DESC')
  end

  def self.reverse_ordered
    joins(:period => :event).order('events.start ASC')
  end

  # returns an array of member_id's
  # e.g. Period.find(342).participants.mem_ids
  # e.g. Period.find(342).participants.has_returned.mem_ids
  def self.mem_ids
    pluck(:member_id)
  end

  def self.by_rank_score
    joins(:membership).order('memberships.rank_score')
  end

  def self.by_sort_key
    all.sort {|x, y| y.sort_key <=> x.sort_key}
  end


  # ----- Instance Methods -----

  # def instrument_create
  #   instrument('event.participant.create')
  # end
  #
  # def instrument_destroy
  #   instrument('event.participant.destroy')
  # end

  # def instrument(tag)
  #   opts = {event_id: event.id, period_id: period.id, membership_id: membership.id}
  #   ActiveSupport::Notifications.instrument tag, opts
  # end

  def check_transit_times
    return if self.returned_at.blank?
    if self.departed_at.blank? || self.departed_at > self.returned_at
      self.departed_at, self.returned_at   = self.returned_at, self.departed_at
    end
  end

  def check_signin_times
    return if self.signed_out_at.blank?
    if self.signed_in_at.blank? || self.signed_in_at > self.signed_out_at
      self.signed_in_at, self.signed_out_at = self.signed_out_at, self.signed_in_at
    end
  end

  # def event
  #   period.event
  # end

  def transit_minutes
    return 0 unless self.departed_at && self.returned_at
    ((self.departed_at - self.returned_at) / 60).round.abs
  end

  def signin_minutes
    return 0 unless self.signed_in_at && self.signed_out_at
    ((self.signed_out_at - self.signed_in_at) / 60).round.abs
  end

  def report_minutes
    [transit_minutes, signin_minutes].max
  end

  def total_minutes
    rm = report_minutes
    rm == 0 ? 'TBD' : rm
  end

  def start_at
    if transit_minutes.abs > signin_minutes.abs
      self.departed_at
    else
      self.signed_in_at
    end
  end

  def finish_at
    if transit_minutes.abs > signin_minutes.abs
      self.returned_at
    else
      self.signed_out_at
    end

  end

  def total_hours
    tm = total_minutes
    return 'TBD' if tm == 'TBD'
    return 'TBD' if tm.nil?
    (tm.to_f / 60).round(1)
  end

  def set_sign_in_times
    event = self.period.try(:event)
    return unless event.try(:typ) == 'meeting'
    self.update_attributes signed_in_at: event.start, signed_out_at: event.finish
  end

  def sort_key
    er_score = event.team.event_roles.sort_score(role)
    me_score = membership.rank_score
    er_score + me_score
    result = [er_score, me_score, membership.last_name]
    dev_log "SORT KEY #{result}"
    result
  end

end

# == Schema Information
#
# Table name: event_participants
#
#  id              :integer          not null, primary key
#  membership_id   :integer
#  event_period_id :integer
#  role            :string(255)
#  comment         :string(255)
#  departed_at     :datetime
#  returned_at     :datetime
#  signed_in_at    :datetime
#  signed_out_at   :datetime
#  created_at      :datetime
#  updated_at      :datetime
#
