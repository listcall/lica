puts ' TARGET ENVIRONMENT: LN6 '.center(70, '-')

set :stage,     :ln6
set :user,      'deploy'

# set :branch,    "dev"
set :branch,    'master'

set :rails_env, 'production'

role :app, ['deploy@x440h64']
role :db,  ['deploy@x440h64']
role :web, ['deploy@x440h64']


