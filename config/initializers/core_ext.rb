require 'active_support/core_ext'

class Time
  def show
    self.strftime('%a %b %d %H:%M')
  end

  def current_week
    (self.strftime('%U').to_i % 13) + 1
  end

  def current_quarter
    base_quarter = case beginning_of_quarter.month
                     when 1  then 1
                     when 4  then 2
                     when 7  then 3
                     when 10 then 4
                   end
    if base_quarter == 4 && current_week == 1
      1
    else
      base_quarter
    end
  end

  def current_year
    base_year = self.year
    if self.month == 12 && current_week == 1
      base_year + 1
    else
      base_year
    end
  end

end

class Numeric
  def quarters
    ActiveSupport::Duration.new(self * 91.days, [[:days, self * 91]])
  end
  alias :quarter :quarters
end

class String
  def end_br
    self.blank? ? '' : self + '<br/>'
  end

  def end_nl
    self.blank? ? '' : self + "\n"
  end

  def end_sp
    self.blank? ? '' : self + ' '
  end

  def capitalize_all
    gsub(/[^ \-]+/) {|x| x.capitalize }
  end
end
