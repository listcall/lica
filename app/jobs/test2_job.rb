class Test2Job < ActiveJob::Base
  queue_as :default

  def perform(*args)
    puts "TEST2 HELLO THERE at #{Time.now} #{args}"
  end
end
