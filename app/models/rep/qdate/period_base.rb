require 'time'
require_relative './range_data'

class Rep::Qdate::PeriodBase
  attr_accessor :range

  def initialize(range = nil)
    @range = range || default_range
  end

  def start;  raise 'start: implement in subclass!';                         end
  def finish; raise 'finish: Implement in subclass!';                        end
  def type;   self.class.name.downcase.gsub('rep::qdate::period','').to_sym; end

  private

  def default_range
    Time.now.strftime('%Y-%m')
  end

  def data
    @data ||= Rep::Qdate::RangeData.new(@range)
  end

  def offset(base)
    return 0 if base.to_i == 0
    class_offset(base)
  end

  def class_offset(base)
    raise 'class_offset: implement in subclass'
  end

end

class Rep::Qdate::PeriodMonth < Rep::Qdate::PeriodBase
  def start
    if data.offset_s.present?
      offset = data.offset_s.to_i
      (Time.now + offset.months).beginning_of_month.strftime('%Y-%m-01')
    else
      "#{data.year_s}-#{data.month_s || "01"}-01"
    end
  end

  def finish
    return end_of_month unless data.span.present?
    if data.offset_f.present?
      offset = data.offset_f.to_i
      day = (Time.now + offset.months).beginning_of_month
      day = day - 1.day if data.span == 'exclusive'
      day.end_of_month.strftime('%Y-%m-%d')
    else
      day = Time.parse("#{data.year_f}-#{data.month_f || "01"}-01")
      day = day - 1.day if data.span == 'exclusive'
      day.end_of_month.strftime('%Y-%m-%d')
    end
  end

  private

  def end_of_month
    Time.parse(start).end_of_month.strftime('%Y-%m-%d')
  end
end

class Rep::Qdate::PeriodQuarter < Rep::Qdate::PeriodBase
  def start
    if data.offset_s.present?
      offset = data.offset_s.to_i
      (Time.now + offset.quarters).beginning_of_quarter.strftime('%Y-%m-01')
    else
      day = Time.parse("#{data.year_s}-#{data.month_s}-01")
      day.beginning_of_quarter.strftime('%Y-%m-01')
    end
  end

  def finish
    return end_of_quarter unless data.span.present?
    if data.offset_f.present?
      offset = data.offset_f.to_i
      day = (Time.now + offset.quarters).beginning_of_quarter
      day = day - 1.day if data.span == 'exclusive'
      day.end_of_quarter.strftime('%Y-%m-%d')
    else
      day = Time.parse("#{data.year_f}-#{data.month_f || "01"}-01")
      day = day - 1.day if data.span == 'exclusive'
      day.end_of_quarter.strftime('%Y-%m-%d')
    end
  end

  private

  def end_of_quarter
    Time.parse(start).end_of_quarter.strftime('%Y-%m-%d')
  end
end

class Rep::Qdate::PeriodYear < Rep::Qdate::PeriodBase
  def start
    if data.offset_s.present?
      offset = data.offset_s.to_i
      (Time.now + offset.years).beginning_of_year.strftime('%Y-%m-01')
    else
      day = Time.parse("#{data.year_s}-#{data.month_s}-01")
      day.beginning_of_year.strftime('%Y-%m-01')
    end
  end

  def finish
    return end_of_year unless data.span.present?
    if data.offset_f.present?
      offset = data.offset_f.to_i
      day = (Time.now + offset.years).beginning_of_year
      day = day - 1.day if data.span == 'exclusive'
      day.end_of_year.strftime('%Y-%m-%d')
    else
      day = Time.parse("#{data.year_f}-#{data.month_f || "01"}-01")
      day = day - 1.day if data.span == 'exclusive'
      day.end_of_year.strftime('%Y-%m-%d')
    end
  end

  private

  def end_of_year
    Time.parse(start).end_of_year.strftime('%Y-%m-%d')
  end
end