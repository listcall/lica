class Avail::Days
  attr_reader :list

  # takes an empty array, an array of Avail::Day or a single Avail::Day
  def initialize(list = [])
    @list = Array(list)
  end

  def busy_on?(date)
    raise "Must supply a date" unless date.is_a?(Date)
    return false if @list.empty?
    @list.detect {|r| r.period.include?(date)}
  end
end