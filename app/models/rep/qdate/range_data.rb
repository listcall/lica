require 'ostruct'
require 'parsers/range_parser'
require_relative './range_normalizer'

class Rep::Qdate::RangeData

  extend Forwardable

  attr_reader :range
  def_delegators :data, :year_s, :month_s, :offset_s, :span
  def_delegators :data, :year_f, :month_f, :offset_f

  def initialize(range = default_range)
    @range = range
  end

  private

  def data
    @data ||= parse(range)
  end

  def parse(input)
    data      = Rep::Qdate::RangeNormalizer.new
    data.hash = stringify(Parsers::RangeParser.new.parse(input))
    data
  end

  def default_range
    Time.now.strftime('%Y-%m')
  end

  def stringify(input)
    input.reduce({}) {|acc, (key,val)| acc[key.to_s] = val.to_s; acc}
  end
end