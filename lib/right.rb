class Right

  include Comparable

  attr_reader :value

  def initialize(input = 'guest')
    self.value = input
  end

  def <=>(other)
    options.index(Right(other).value) <=> options.index(value)
  end

  def to_s
    value.to_s
  end

  def to_sym
    value.to_sym
  end

  def value=(input)
    @value = input.is_a?(Right) ? input.value : input.to_s
    raise "Invalid Right (#{input})" unless valid?
  end

  def score
    options.index(value) + 1
  end

  class << self
    def options
      %w(owner manager active reserve guest alum inactive)
    end
  end

  private

  def options
    self.class.options
  end

  def valid?
    self.class.options.include?(value)
  end
end

# conversion function
def Right(value)
  case value
  when Right then value
  else
    Right.new(value)
  end
end