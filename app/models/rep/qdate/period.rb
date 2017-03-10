load __dir__ +  '/period_base.rb'

class Rep::Qdate::Period
  attr_accessor :type, :start, :finish

  VALID_TYPES ||= %i(month quarter year)

  class << self

    def default_params
      { month: Time.now.strftime('%Y-%m') }
    end

    def build(params = nil)
      params = default_params if params.nil? || params == {}
      tgt_param = params.to_a.first
      type      = tgt_param.first.to_s.downcase.singularize.to_sym
      range     = tgt_param.last.to_s.strip
      raise "Invalid Period Type (#{type})" unless VALID_TYPES.include?(type)
      class_str = "Rep::Qdate::Period#{type.to_s.capitalize}"
      klas      = eval class_str
      klas.new(range)
    end
  end
end
