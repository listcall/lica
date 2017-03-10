# takes an input has from the RangeParser
# makes start/finish data available (year/month/offset)
# quarters are mapped to months
# months always reports in two-digit integers

class Rep::Qdate::RangeNormalizer

  attr_reader :hash

  def initialize(hash = {})
    @hash = hash
  end

  def hash=(hash)
    @hash = hash
  end

  def year_s
    std_year(_year_s)
  end

  def month_s
    std_month(_month_s) || std_quarter(_quarter_s)
  end

  def offset_s
    std_offset(_current_s)
  end

  def year_f
    span.nil? ? nil : std_year(_year_f)
  end

  def month_f
    span.nil? ? nil : std_month(_month_f) || std_quarter(_quarter_f)
  end

  def offset_f
    std_offset(_current_f)
  end

  def span
    case hash['span']
    when '..'  then 'inclusive'
    when '...' then 'exclusive'
    else nil
    end
  end

  private

  def _year_s    ; hash['year_s']    ; end
  def _month_s   ; hash['month_s']   ; end
  def _quarter_s ; hash['quarter_s'] ; end
  def _current_s ; hash['current_s'] ; end
  def _year_f    ; hash['year_f']    ; end
  def _month_f   ; hash['month_f']   ; end
  def _quarter_f ; hash['quarter_f'] ; end
  def _current_f ; hash['current_f'] ; end

  def std_year(input)
    input || current_year
  end

  def std_month(input)
    return nil if input.nil?
    tgt = month_table.find {|item| item.match(/#{input.downcase}/)}
    tgt && tgt.split.first
  end

  def std_quarter(input)
    return nil if input.nil?
    tgt = quarter_table.find {|item| item.match(/#{input.downcase}/)}
    tgt && tgt.split.first
  end

  def std_offset(input)
    return nil if input.nil?
    result = input.upcase.gsub(/CURRENT|CUR|C/, '').gsub(' ', '+')
    result.present? ? result : '0'
  end

  def current_year
    Time.now.strftime('%Y')
  end

  def month_table
    [
      '01 1 jan janruary'     ,
      '02 2 feb february'     ,
      '03 3 mar march'        ,
      '04 4 apr april'        ,
      '05 5 may may'          ,
      '06 6 jun june'         ,
      '07 7 jul july'         ,
      '08 8 aug august'       ,
      '09 9 sep september'    ,
      '10   oct october'      ,
      '11   nov november'     ,
      '12   dec december'     ,
    ]
  end

  def quarter_table
    [
      '01 q1 quarter1'    ,
      '04 q2 quarter2'    ,
      '07 q3 quarter2'    ,
      '10 q4 quarter2'    ,
    ]
  end
end