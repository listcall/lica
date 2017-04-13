source 'https://rubygems.org'

# ----- ruby -----
ruby '2.4.0'                  # must match .ruby-version

# ----- for handling github gems -----
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# ----- rails -----
gem 'rails', '~> 5.1.0.rc1'   # rails

# ----- environment -----
gem 'dotenv-rails'

# ----- servers -----
gem 'puma', '~> 3.7'              # web server

# ----- database -----
gem 'pg',     '~> 0.18'           # postgresql SQL database
gem 'redis',  '~> 3.0'            # key-value datastore (job queueing)
gem 'dalli'                       # memcached support (caching)
gem 'dalli-ui'                    # web interface for memcached
gem 'connection_pool'             # dalli helper for puma (multi-threaded)

# ----- misc -----
# gem 'active_importer'              # import csv and spreadsheet files
# gem 'workflow'                     # finite state machine

# ----- template processors -----
gem 'slim-rails'            # slim templates
gem 'jbuilder' , '~> 2.5'   # json templates
gem 'prawn'    , '0.12.0'   # pdf generation

# ----- background processing -----
gem 'sidekiq'                   # background job queue manager
gem 'sinatra',  require: nil    # needed by Sidekiq UI
gem 'rake'                      # needed by Sidekiq

# ----- scheduled jobs -----
gem 'whenever', require: nil    # cron jobs - see 'schedule.rb'

# ----- support utilities -----
gem 'json'                                # json serialization
gem 'parslet'                    # for address and name parsers
gem 'cancan'                     # access control
gem 'responders'   , '~> 2.0'    # helper methods, extended flash messages
gem 'bcrypt'       , '~> 3.1.7'  # encryption for 'has-secure-password'
gem 'ruby_identicon'             # generates default identicons
gem 'exception_notification'     # sends alert emails on 500 errors

# ----- active-record helpers -----
gem 'acts_as_list'      # order objects by position field
gem 'ancestry'          # manage objects in a tree-structure
gem 'sequenced'         # generate scoped IDs
gem 'enumerize'         # hstore helpers for enum fields
gem 'hstore_accessor'   # hstore data-fields and querying
gem 'jsonb_accessor'    # jsonb data-fields and querying
gem 'counter_culture'   # counter caches in parent objects
gem 'active_type'       # extensions for ActiveModel

# ----- view utilities -----
# gem 'simple_form', '~> 3.2.0' # form generator
gem 'simple_form'             # form generator
# gem 'active_link_to'          # for creating bootstrap nav bars
gem 'launchy'                 # static page launcher


# ----- audit trails, versioning and activity logs -----
# gem 'paper_trail'
 
# ----- images and attachments -----
gem 'paperclip'                   # file attachments
gem 'mini_magick'                 # server-side image resizing & cropping

# ----- asset packaging -----
# gem 'sprockets'        , '3.6.3'
# gem 'sprockets-rails'  , '~> 3.1'
# gem 'sass-rails', github: "rails/sass-rails"  # sass processor based on libsass
gem 'webpacker'                                 # webpack support
# gem 'webpacker', github: "rails/webpacker"                                 # webpack support

# ----- asset management -----
gem 'therubyracer' , platforms: :ruby  # javascript execution engine
gem 'uglifier'     , '>= 1.0.3'        # javascript minifier
gem 'coffee-rails' , '~> 4.2.0'        # coffeescript support
gem 'bh'           , '~> 1.3.6'        # bootstrap helpers

# ----- javascript packages / gems -----
gem 'jquery-ui-rails'        , '4.2.1'    # jquery UI
gem 'bootstrap-sass'         , '~> 3.3'   # bootstrap UI framework
gem 'bootstrap-switch-rails' , '1.8.1'    # bootstrap on-off switch

# ----- javascript packages / http://rails-assets.org -----
source 'https://rails-assets.org' do
  gem 'rails-assets-jquery', '~> 1.11.1'    # jquery
  gem 'rails-assets-d3'                     # charting/analytics
  gem 'rails-assets-nvd3'                   # pre-canned d3 charts
  gem 'rails-assets-moment'                 # date manipulation
  gem 'rails-assets-lodash'                 # JS utilities
  gem 'rails-assets-select2', '~> 3.5.2'    # enhanced select fields
  gem 'rails-assets-select2-bootstrap'      # bootstrap css for select2
  gem 'rails-assets-modernizr', '~> 2.8.3'  # browser testing
  gem 'rails-assets-handlebars'             # report templates
  gem 'rails-assets-fullcalendar'           # calendaring
  gem 'rails-assets-jquery-cookie'          # cookie manipulation
  gem 'rails-assets-jquery.tablesorter', '2.21.2' # table sorting
  gem 'rails-assets-sweetalert'        , '0.5.0'  # enhanced alert
  gem 'rails-assets-react', '0.13.1'        # ReactJS
  gem 'rails-assets-react-bootstrap'        # Bootstrap Components for ReactJS
  gem 'rails-assets-reflux'                 # flux implementation for ReactJS
  gem 'rails-assets-griddle'                # react grid component
  gem 'rails-assets-keymaster'              # keyboard handler
end

# ----- email services -----
gem 'mailgun-ruby'        # outbound mail and provisioning for mailgun
# gem 'mandrill-rails'      # incoming mail and webhooks from mandrill
# gem 'mandrill-api'        # outbound mail and provisioning - see mandrillapp.com
gem 'email_reply_parser'  # remove email reply quotes and signatures

# ----- sms services -----
gem 'nexmo'               # SMS service provider
gem 'plivo'               # SMS service provider

# ----- dns services -----
gem 'dnsimple'            # DNS service provider

# ----- api support -----
gem 'grape'                 # api engine
gem 'grape-swagger'         # swagger generator for grape
gem 'grape-swagger-rails'   # swagger UI
# gem 'rack-contrib'          # jsonp callbacks - THIS CAUSES MIGRATION BUG !!

# ----- console tools -----
gem 'hirb'          # table-display
gem 'wirble'        # colorized IRB display
gem 'colored'       # colored output - `puts "asdf".red`
gem 'awesome_print' # enhanced pp - colors and indenting

# ----- pry production support  -----
gem 'pry-rails'     # upgraded repl

group :development, :test do

  # ----- pry / development support -----
  gem 'pry-doc'                        # doc functions
  gem 'pry-docmore'                    # more doc functions
  gem 'pry-byebug'                     # debugger
  gem 'pry-rescue'                     # opens pry on failing test
  gem 'pry-stack_explorer'             # stack display and navigation

  # ----- rails4.1 workaround for should/rspec error message -----
  gem 'minitest'

  # ----- coffeescript -----
  # gem 'coffee-rails-source-maps'

  # ----- rspec -----
  gem 'webrat'                           # 'contain' matcher for view specs
  gem 'capybara'                         # used for feature specs
  gem 'poltergeist'                      # javascript testing in capybara
  gem 'rspec-rails'                      # RSPEC
  gem 'database_cleaner'                 # reset DB between tests
  gem 'factory_girl_rails'               # for data import and testing
  gem 'shoulda-matchers'                 # 'should_belong_to' matchers
  gem 'selenium-webdriver'               # web driver

  # ----- test runners - guard/spring -----
  gem 'guard'                       # auto test-runner
  gem 'spring'                      # rails pre-loader
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'listen'                      # guard listener
  gem 'rb-inotify'                  # file-system watcher used by guard
  gem 'spring-commands-rspec'       # 'spring rspec' command
  gem 'guard-rspec_min' , github: 'andyl/guard-rspec_min'

  # ----- email testing -----
  gem 'ultrahook'       # for testing inbound mandrill mail on dev

end

group :development do

  # ----- capistrano -----
  gem 'capistrano'           # app deployment
  gem 'capistrano-rails'     # rails-specific tasks
  gem 'capistrano-bundler'   # bundler-specific tasks

  # ----- documentation, metrics, logging -----
  gem 'bullet'                      # shows N+1 queries
  gem 'traceroute'                  # unused routes    | 'rake traceroute'
  gem 'rails-erd'  , require: false # erg generation   | 'bundle exec erd'
  gem 'rubocop'    , require: false # style analyzer   | 'rubocop -R'
  gem 'brakeman'   , require: false # security scanner | 'brakeman'
  gem 'sandi_meter', require: false # code analyzer    | 'sandi_meter'
  gem 'annotate'   , require: false # 'be annotate -d ; be annotate -p after'
  gem 'rails_best_practices' , require: false

  gem 'better_errors'          # improved error dump
  gem 'binding_of_caller'      # better_errors repl

  # ----- vim automation -----
  gem 'gem-browse'

end
