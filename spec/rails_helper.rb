ENV['RAILS_ENV'] ||= 'test'

require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'shoulda-matchers'

require 'database_cleaner'
require 'parslet/rig/rspec'    # parslet matchers...
require 'factory_girl_rails'   # object factories...

require 'launchy'
require 'capybara/rspec'
require 'capybara/rails'
require 'capybara/poltergeist'

class NullIO
  def puts(*args)
  end
end

# from https://github.com/teampoltergeist/poltergeist/issues/375
Capybara.register_driver(:poltergeist) do |cfg|
  opts = {
    logger:    nil,
    timeout:   180,
    js_errors: false,
    phantomjs: 'phantomjs211',
    phantomjs_logger:  NullIO.new,
    phantomjs_options: %w(--load-images=no --ignore-ssl-errors=yes)
  }
  # noinspection RubyArgCount
  Capybara::Poltergeist::Driver.new(cfg, opts)
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library        :rails
  end
end

# if this is commented out, Capybara will use the default selenium driver
# Capybara.javascript_driver = :webkit
Capybara.javascript_driver = :poltergeist

require "#{Rails.root.to_s}/spec/timeout_workaround"

require 'sidekiq/testing'
require 'sidekiq/testing/inline'
Sidekiq::Logging.logger = nil

RSpec::Expectations.configuration.on_potential_false_positives = :nothing

# Require custom matchers / macros / etc.  Ruby files only - not `*._spec.rb`.
require Rails.root.join('spec/rails_support.rb')
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
# Checks for pending migrations before tests are run.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods  # create(:obj) / build(:obj)
  config.infer_spec_type_from_file_location!   # auto-set Rails Spec type

  config.use_transactional_fixtures = false

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before(:suite) do
    DatabaseCleaner.clean_with(:transaction)
  end
  config.before(:each) do |example|
    is_request = example.metadata[:type] == :requests
    alt_driver = Capybara.current_driver != :rack_test
    if is_request || alt_driver
      DatabaseCleaner.strategy = :truncation
    else
      DatabaseCleaner.strategy = :transaction
    end
    DatabaseCleaner.start
  end
  config.after(:each) do
    # puts "CLEANING EACH"
    DatabaseCleaner.clean
  end
  config.after(:suite) do
    # puts "CLEANING SUITE"
    TestClean.all
  end
end
