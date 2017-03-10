module Kernel
  def err_log(*msgs)
    base_log(*(msgs.map(&:to_s)), char: '>', color: 'red')
  end

  def info_log(*msgs)
    base_log(*(msgs.map(&:to_s)), char: '*', color: 'blue')
  end

  def green_log(*msgs)
    base_log(*(msgs.map(&:to_s)), char: '-', color: 'green')
  end

  def purple_log(*msgs)
    base_log(*(msgs.map(&:to_s)), char: '-', color: 'purple')
  end

  def dev_log(*msgs, color: 'yellow', char: '=')
    base_log(*(msgs.map(&:to_s)), color: color, char: char)
  end

  def tst_log(*msgs, color: 'yellow', char: '=')
    base_log(*(msgs.map(&:to_s)), run_on_test: true, color: color, char: char)
  end

  def data_log(*msgs)
    return if Rails.env == 'test'
    msgs.map(&:to_s).each do |msg|
      puts msg.purple
      $stdout.flush
    end
  end

  private

  def base_log(*msgs, char: '=', color: 'yellow', run_on_test: false)
    return if Rails.env == 'test' && run_on_test == false
    ref  = caller[1]
    file = ref.match(/([^\/:]+):\d+:/)[1].split('.')[0]
    line = ref.match(/\:(\d+)\:/)[1]
    meth = ref.match(/\`(.+)\'/)[1]
    pref = "#{(' ' + file).rjust(20, char)}:#{line.ljust(2)} #{(meth + ' ').ljust(30,'-')}"
    msgs.each do |msg|
      string = "#{char}#{pref}> #{msg}"
      puts string.send(color)
      $stdout.flush
    end
  end
end