Capistrano::Configuration.instance(:must_exist).load do

  #after 'deploy:update', 'foreman:export'
  #after 'deploy:update', 'foreman:restart'
  #after 'deploy:rollback:revision', 'foreman:export_rollback'

  namespace :foreman do
    desc "Export the Procfile to Ubuntu's upstart scripts"
    task :export, :roles => :app do
      run "sudo rm -f /etc/init/#{ fetch(:app_name) }*.conf"
      run "cd #{release_path} && foreman export upstart /tmp/xinit -e .env -p #{ fetch(:web_port) } -a #{ fetch(:app_name) } -u #{ fetch(:user) } -l #{shared_path}/log"
      run 'sudo mv /tmp/xinit/* /etc/init'
      run 'rm -rf /tmp/xinit'
    end
    task :export_rollback, :roles => :app do
      run "sudo stop #{ fetch(:app_name) }"
      run "sudo rm -f /etc/init/#{ fetch(:app_name) }*.conf"
      run "cd #{current_path} && foreman export upstart /tmp/xinit -e .env -p #{ fetch(:web_port) } -a #{ fetch(:app_name) } -u #{ fetch(:user) } -l #{shared_path}/log"
      run 'sudo mv /tmp/xinit/* /etc/init'
      run "sudo start #{ fetch(:app_name) }"
      run 'rm -rf /tmp/xinit'
    end
    desc 'Start the application services'
    task :start, :roles => :app do
      run "sudo start #{ fetch(:app_name) }"
    end

    desc 'Stop the application services'
    task :stop, :roles => :app do
      run "sudo stop #{ fetch(:app_name) }"
    end

    desc 'Restart the application services'
    task :restart, :roles => :app do
      run "sudo start #{ fetch(:app_name) } || sudo restart #{ fetch(:app_name) }"
    end
  end

end
