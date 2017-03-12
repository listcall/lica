Capistrano::Configuration.instance(:must_exist).load do

  # ----- keys -----
  before 'deploy:assets:precompile',  'keys:upload'

  def update_rails_env(txt)
    txt.gsub('RAILS_ENV=development', "RAILS_ENV=#{rails_env}")
  end

  namespace :keys do

    desc 'upload keys'
    task :upload do
      if File.exist? '.env'
        dev_env = File.read('.env')
        new_env = update_rails_env(dev_env)
        put new_env, "#{release_path}/.env"
      else
        puts ' NOTICE - no private keyfile '.center(80, '*')
      end
    end

  end

end

