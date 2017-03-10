require 'app_ext/pkg'
require 'weekly_dates'

class Position::Period < ActiveRecord::Base

  extend Forwardable
  include WeeklyDates

  # ----- attributes -----
  def_delegators  :position, :weekly_rotation_day, :weekly_rotation_time

  # ----- associations -----
  belongs_to :position , touch: true
  has_many   :position_bookings, :class_name => 'Position::Booking', :foreign_key => 'position_period_id'

  alias_method :bookings, :position_bookings

  # ----- callbacks -----

  # ----- validations -----

  # ----- scopes -----

  # ----- klass methods -----

  # ----- local methods -----

  def current_weekly_period
    now = Time.now
    weekly_start < now && now < weekly_finish
  end

  def avails
    team_id = position.team.id
    opts = {team_id: team_id, year: year, quarter: quarter, week: week}
    Avail::Week.where(opts)
  end

  def avail_member_ids
    result = avails
    return [] if result.blank?
    result.pluck(:membership_id).uniq
  end
end

# == Schema Information
#
# Table name: position_periods
#
#  id          :integer          not null, primary key
#  position_id :integer
#  assignee_id :integer
#  year        :integer
#  quarter     :integer
#  week        :integer
#  jfields     :jsonb            default("{}")
#  xfields     :hstore           default("")
#  created_at  :datetime
#  updated_at  :datetime
#
