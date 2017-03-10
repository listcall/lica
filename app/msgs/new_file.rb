class NewFile

  DIV = "=============================================================================="

  def self.say_bing
    say_text "BING"
    binding.pry
  end

  def self.say_bong
    say_text "BONG"
    binding.pry
  end

  def self.say_text(text)
    puts DIV
    puts "#{text} #{text}"
    puts DIV
  end
end