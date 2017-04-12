class Test1Job < ActiveJob::Base
  queue_as :default

  def perform(*args)
    puts "TEST1 HELLO THERE at #{Time.now} #{args}"
  end
end
