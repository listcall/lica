class UnAvails

  attr_reader :member, :members, :start, :finish

  def initialize(members, start_arg = nil, finish_arg = nil)
    @member  = nil
    @members = members
    @start   = Date.parse(start_arg  || default_start)
    @finish  = Date.parse(finish_arg || default_finish)
  end

  def for(member)
    @member = member
    self
  end

  def busy_on?(date)
    raise "No Member" if member.nil?
    return false unless records[member.id].present?
    records[member.id].find {|x| x.period && x.period.include?(date.to_date)}
  end

  def return_date(date)
    raise "No Member" if member.nil?
    return nil unless records[member.id].present?
    records[member.id].last.finish
  end

  def current_comment
    raise "No Member" if member.nil?
    return nil unless records[member.id].present?
    records[member.id].first.comment
  end

  def busy_dates
    members.reduce({}) do |acc, mem|
      acc[mem.user_name] = busy_dates_for(mem)
      acc
    end
  end

  private

  def busy_dates_for(mem)
    @member = mem
    (start..finish).map do |date|
      busy_on?(date) ? date.strftime("%-m/%-d") : nil
    end.compact
  end

  def records
    @records ||= query_records
  end

  def query_records
    records = Avail::Day.where(membership: members)#.within(start, finish)
    records.reduce({}) do |acc, unavail|
      mem_id = unavail.membership_id
      acc[mem_id] ||= []
      acc[mem_id] << unavail
      acc
    end
  end

  def default_start
    (Date.today - 3.days).to_s
  end

  def default_finish
    (Date.today + 10.days).to_s
  end
end
