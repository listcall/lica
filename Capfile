# only run in master branch 
branch = `git rev-parse --abbrev-ref HEAD`.chomp
puts "CURRENT BRANCH <#{branch}>"
abort "EXITING: CAP ONLY RUNS IN MASTER BRANCH" unless branch == "master"

# environment variables
require 'dotenv'

Dotenv.load

require __dir__ + '/lib/env_settings'

# foundation tasks
require 'capistrano/setup'
require 'capistrano/deploy'

# plugin tasks
require 'capistrano/bundler'
require 'capistrano/rails/migrations'

# custom tasks from `lib/capistrano/tasks'
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }

#
