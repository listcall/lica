class Event::Period < ActiveRecord::Base

  has_ancestry :orphan_strategy => :rootify

  # ----- Associations -----

  belongs_to  :event       , touch: true
  has_many    :participants, dependent: :destroy, foreign_key: 'event_period_id', class_name: 'Event::Participant'
  has_many    :reports     , dependent: :destroy, foreign_key: 'event_period_id', class_name: 'Event::Report'

  counter_culture :event, column_name: 'event_periods_count'

  # ----- Callbacks -----
  before_create :check_position

  # ----- Validations -----
  validates_presence_of :event_id
  # validates_presence_of :event

  # ----- Scopes -----
  scope :sorted, -> { order('position ASC').order(:created_at) }

  # ----- Local Methods-----

  def check_position
    self.position = 1 if self.position.nil?
  end

  def descendant_participants
    return [] unless self.has_children?
    periods = descendants.sort {|x, y| x.team.acronym <=> y.team.acronym}
    periods.map {|period| period.participants.by_rank_score.to_a}.flatten
  end

  def period_ref
    "#{event.event_ref}_#{position}"
  end

  def team
    event.team
  end

  # ----- support RSVP actions -----

  def add_participant(member)
    mem_id = member.to_i                                      # handle obj or id
    self.participants.first_or_create(membership_id: mem_id)  # idempotent
  end

  def set_departure_time(member)
    return unless (participant = self.participants.by_mem_id(member.id).first)
    return if participant.en_route_at
    participant.update_attributes en_route_at: Time.now
  end

  def set_return_time(member)
    return unless (participant = self.participants.by_mem_id(member.id).first)
    return if participant.return_home_at
    participant.update_attributes return_home_at: Time.now
  end
end

# == Schema Information
#
# Table name: event_periods
#
#  id          :integer          not null, primary key
#  event_id    :integer
#  position    :integer
#  location    :string(255)
#  start       :datetime
#  finish      :datetime
#  external_id :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  ancestry    :string(255)
#
