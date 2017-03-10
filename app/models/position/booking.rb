require 'app_ext/pkg'
require 'weekly_dates'

class Position::Booking < ActiveRecord::Base

  extend Forwardable
  include WeeklyDates

  # ----- attributes -----
  # def_delegators  :service_type, :team, :description
  # def_delegators  :service_type, :weekly_rotation_day, :weekly_rotation_time
  # xfield_accessor :color

  # ----- associations -----
  belongs_to :position_period , touch: true, class_name: 'Position::Period', foreign_key: 'position_period_id'
  belongs_to :membership

  # ----- callbacks -----

  # ----- validations -----

  # ----- scopes -----

  # ----- klass methods -----

  # ----- local methods -----

end

# == Schema Information
#
# Table name: position_bookings
#
#  id                 :integer          not null, primary key
#  position_period_id :integer
#  membership_id      :integer
#  xfields            :hstore           default("")
#  jfields            :jsonb            default("{}")
#  created_at         :datetime
#  updated_at         :datetime
#
