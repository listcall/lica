require_relative "./days"

class Avail::Day < ActiveRecord::Base

  self.table_name = 'avail_days'

  # ----- attributes -----

  # ----- associations -----

  belongs_to :team
  belongs_to :membership

  # ----- callbacks -----
  before_save   :update_period
  after_save    :sync_to_svc
  after_destroy :sync_to_svc

  # ----- validations -----
  validates :start, :finish, :presence => true

  # ----- scopes -----
  def self.current(time = Time.now)
    where('start < ?', time).where('finish > ?', time)
  end

  def self.older_than_this_month
    where('finish < ?', Time.now.beginning_of_month)
  end

  def self.for_service(service)
    where(service_type_id: service.type.id)
  end

  def self.within(start, finish)
    where("period && '[#{start}, #{finish})'::daterange").order(:start)
  end

  # ----- local methods -----
  def update_period
    self.finish ||= self.start
    self.period = self.start .. self.finish
  end

  def sync_to_svc
    return unless self.start_changed? || self.finish_changed?
    return unless self.membership_id
    start  = (self.start_change || [self.start]).compact.min
    finish = (self.finish_change || [self.finish]).compact.max
    # TODO - call the service from a background job
    AvailSyncSvc.new(self.membership_id, start, finish)
  end

  def at_start(date)
    @at_start       ||= {}
    @at_start[date] ||= date == start
  end

  def at_finish(date)
    @at_finish       ||= {}
    @at_finish[date] ||= date == finish
  end

  def at_single_day(date)
    @at_single_day       ||= {}
    @at_single_day[date] ||= at_start(date) && at_finish(date)
  end

  def start_bump
    self.update_attribute(:start, self.start + 1.day)
  end

  def finish_bump
    self.update_attribute(:finish, self.finish - 1.day)
  end

  def split_on(date)
    new_period = self.dup
    new_period.start = date + 1.day
    new_period.save
    self.update_attribute(:finish, date - 1.day)
  end

  # ----- klass methods -----

  def self.next_3_months
    start  = Date.today.beginning_of_month
    finish = (start + 75.days).end_of_month
    Avail::Days.new(within(start, finish).to_a)
  end

  def self.periods_on(date)
    date = date.to_date if date.is_a?(Time)
    where('start < ?', date+1).where('finish >= ?', date)
  end

  def self.busy_on?(date)
    result = periods_on(date).count
    result == 0 ? false : true
  end

  def self.return_date(date)
    date   = date.to_date if date.is_a?(Time)
    result = where('start < ?', date+1).where('finish >= ?', date).last
    result.nil? ? nil : result.finish
  end

  def self.find_or_create(params)
    xparams = params.except(:service_id)
    result  = where(xparams).to_a.first
    result.present? ? result : create(xparams)
  end
end

# == Schema Information
#
# Table name: avail_days
#
#  id            :integer          not null, primary key
#  team_id       :integer
#  membership_id :integer
#  status        :string(255)
#  comment       :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  start         :date
#  finish        :date
#  period        :daterange
#
