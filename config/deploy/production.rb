puts ' TARGET ENVIRONMENT: PRODUCTION '.center(70, '-')

set :stage,     :production
set :user,      'deploy'

set :rails_env, 'production'

role :app, ['deploy@x440host']
role :db,  ['deploy@x440host']
role :web, ['deploy@x440host']


