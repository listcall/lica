class AttendanceVal
  attr_reader :event_count, :month_count, :title

  def initialize(title: '', types: '', tags: '', event_count: 1, month_count: 999)
    @title = title
    @types = types
    @tags  = tags
    @event_count = event_count
    @month_count = month_count
  end

  def types
    @types.gsub(',', ' ').upcase.split(' ')
  end

  def tags
    @tags.gsub(',', ' ').downcase.split(' ')
  end

  def has_types?
    types != []
  end

  def has_tags?
    tags != []
  end

  def has_title?
    title.present?
  end

  def has_month_range?
    months != 999
  end

  def months
    month_count.to_i
  end

  def start_range
    Time.now - month_count.to_i.months
  end
end