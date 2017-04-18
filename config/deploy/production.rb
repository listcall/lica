puts ' TARGET ENVIRONMENT: PRODUCTION '.center(70, '-')

set :stage,     :production
set :user,      'deploy'

set :rails_env, 'production'

role :app, ['deploy@lch1']
role :db,  ['deploy@lch1']
role :web, ['deploy@lch1']


