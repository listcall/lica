require 'weekly_dates'

class Avail::Week < ActiveRecord::Base

  extend  Forwardable
  include WeeklyDates

  self.table_name = 'avail_weeks'

  # ----- attributes -----
  def_delegators :team, :weekly_rotation_day, :weekly_rotation_time

  # ----- associations -----
  belongs_to :team
  belongs_to :membership

  # ----- callbacks -----

  # ----- validations -----

  # ----- scopes -----
  scope :undefined, -> { where(status: nil)            }
  scope :avail    , -> { where(status: 'available')    }
  scope :unavail  , -> { where(status: 'unavailable')  }

  def self.current
    where('start < ?', Time.now).where('finish > ?', Time.now)
  end

  def self.older_than_this_month
    where('finish < ?', Time.now.beginning_of_month)
  end

  # ----- klass methods -----
  def self.busy_on?(date)
    date = date.to_date if date.is_a?(Time)
    base_qry = where('start < ?', date+1).where('finish >= ?', date)
    result = base_qry.count
    result == 0 ? false : true
  end

  def self.return_date(date)
    date = date.to_date if date.is_a?(Time)
    base_qry = where('start < ?', date+1).where('finish >= ?', date)
    result = base_qry.last
    result.nil? ? nil : result.to_a.first.try(:finish)
  end
end

# == Schema Information
#
# Table name: avail_weeks
#
#  id            :integer          not null, primary key
#  team_id       :integer
#  membership_id :integer
#  year          :integer
#  quarter       :integer
#  week          :integer
#  status        :string(255)
#  comment       :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#
