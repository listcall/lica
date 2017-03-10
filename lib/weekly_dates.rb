module WeeklyDates

  # ----- generating quarter object from time -----

  def quarter_for(time)
    day_offset, hour_offset = gen_offsets
    actual    = Time.parse(time.to_s)
    offset    = actual - day_offset.days - hour_offset.hours
    {
      year:    offset.current_year,
      quarter: offset.current_quarter,
      week:    offset.current_week
    }
  end

  def current_quarter
    quarter_for(Time.now)
  end

  # ----- return start/finish times from quarter object -----

  def weekly_start_for(qhash)
    day_offset, hour_offset = gen_offsets
    quarter_start = Time.new(qhash[:year].to_s) + (qhash[:quarter].to_i-1).quarters
    sun_start     = quarter_start - quarter_start.wday.days
    week_start    = sun_start  + (qhash[:week].to_i-1).weeks
    day_start     = week_start + day_offset.days
    hour_start    = day_start  + hour_offset.hours
    hour_start
  end

  def weekly_finish_for(qhash)
    weekly_start_for(qhash) + 1.week - 1.minute
  end

  # ----- return start/finish times from current object -----

  def weekly_start
    weekly_start_for(year: year, quarter: quarter, week: week)
  end

  def weekly_finish
    weekly_finish_for(year: year, quarter: quarter, week: week)
  end

  private

  def gen_offsets
    hour_offset = weekly_rotation_time.split(':').first.to_i
    day_offset  = case weekly_rotation_day
                  when 'Sun' then 0
                  when 'Mon' then 1
                  when 'Tue' then 2
                  when 'Wed' then 3
                  when 'Thu' then 4
                  when 'Fri' then 5
                  when 'Sat' then 6
                  else 0
                  end
    [day_offset, hour_offset]
  end
end