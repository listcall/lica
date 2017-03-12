puts ' CAP CONFIG BASE '.center(70,'-')

# ===== App Config =====

set :application, 'LICA'
set :log_level,   :info     # use :warn, :info or :debug

set :deploy_to,   -> { "/home/#{fetch(:user)}/a/#{fetch(:application).downcase}" }

# ===== Nginx Config =====

set :vhost_names, %w(smsoesb.net *.smsoesb.net lica.com)
set :web_port,    8500

# ===== Source Access =====

set :scm,              :git
set :repo_url,         'ssh://git@github.com/listcall/list_call.git'
before 'deploy:check', 'setup:netrc'  # supplies username/password for access to private repo

# ===== Tasks =====

after 'deploy:symlink:shared', 'assets:precompile'
after 'deploy:symlink:shared', 'data:rsync'
after 'deploy:symlink:shared', 'data:varfile'

# ===== Symlinking =====

set :linked_dirs,  %w{data log tmp/pids tmp/cache tmp/sockets public/util public/system public/assets}

# ===== Bundler =====

set :bundle_flags,    '--deployment --quiet'
set :bundle_without,  'development test'
set :bundle_gemfile,  -> { release_path.join('Gemfile') }
set :bundle_dir,      -> { shared_path.join('bundle')   }
# set :bundle_binstubs, -> { shared_path.join('bin')      }
set :bundle_roles,    :all

# ===== Misc Config =====

set :keep_releases, 5
set :default_env, { RAILS_ENV: 'production' }

# ===== Deploy Tasks =====

namespace :deploy do

  desc 'Restart application'
  task :restart do
    invoke 'foreman:export'
    on roles(:app) do
      debug ' RESTART '.center(80,'-')
      debug ' TODO: FIX THE BROKEN KILL SIGNALS '.center(80,'-')
      # restart PUMA
      # execute "(kill -s SIGUSR1 $(ps -C ruby -F | grep '/puma' | awk {'print $2'})) || sudo restart #{fetch(:application)} || sudo start #{fetch(:application)}"
      # restart SIDEKIQ
      # execute "(kill -s TERM $(ps -C ruby -F | grep 'sidekiq' | awk {'print $2'})) || sudo restart #{fetch(:application)} || sudo start #{fetch(:application)}"
      execute "sudo restart #{fetch(:application)} || sudo start #{fetch(:application)}"
    end
  end

  after  :publishing , :restart
  after  :finishing  , :cleanup
  after  :cleanup    , 'foreman:symlink_logs'

end
