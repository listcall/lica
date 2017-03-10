CAPYBARA_TIMEOUT_RETRIES = 3

def restart_phantomjs
  puts '-> Restarting phantomjs: iterating through capybara sessions...'
  session_pool = Capybara.send('session_pool')
  session_pool.each do |mode,session|
    msg = "  => #{mode} -- "
    driver = session.driver
    if driver.is_a?(Capybara::Poltergeist::Driver)
      msg += 'restarting'
      driver.restart
    else
      msg += "not poltergeist: #{driver.class}"
    end
    puts msg
  end
end

RSpec.configure do |config|
  # config.around(:each, type: :feature) do |ex|
  #   example = RSpec.current_example
  #   CAPYBARA_TIMEOUT_RETRIES.times do |i|
  #     example.instance_variable_set('@exception', nil)
  #     self.instance_variable_set('@__memoized', nil) # clear let variables
  #     ex.run
  #     break unless example.exception.is_a?(Capybara::Poltergeist::TimeoutError)
  #     puts("\nCapybara::Poltergeist::TimeoutError at #{example.location}\n   Restarting phantomjs and retrying...")
  #     restart_phantomjs
  #   end
  # end
end
