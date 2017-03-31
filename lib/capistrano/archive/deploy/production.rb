puts ' Target Environment: PRODUCTION '.center(70, '-')

set :user,      'deploy'
set :handler,   'lica'
set :branch,    fetch(:branch, 'master')
set :rails_env, fetch(:env,    'production')

set :keep_releases, 10

set :format_options, :banner => :auto

server proxy, :app, :web, :db, :primary => true
