# only run in dev branch
branch = `git rev-parse --abbrev-ref HEAD`.chomp
puts "CURRENT BRANCH <#{branch}>"
puts ' TARGET ENVIRONMENT: VAGRANT '.center(70, '-')

abort "EXITING: VAGRANT CAP ONLY RUNS IN DEV BRANCH" unless branch == "dev"

set :stage,     :vagrant
set :user,      'deploy'

set :branch,    'dev'

set :rails_env, 'staging'

role :app, ['deploy@tstlica']
role :db,  ['deploy@tstlica']
role :web, ['deploy@tstlica']
