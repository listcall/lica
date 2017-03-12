puts ' TARGET ENVIRONMENT: VAGRANT '.center(70, '-')

set :stage,     :vagrant
set :user,      'deploy'

set :branch,    'master'

set :rails_env, 'production'

role :app, ['deploy@vagrant']
role :db,  ['deploy@vagrant']
role :web, ['deploy@vagrant']

