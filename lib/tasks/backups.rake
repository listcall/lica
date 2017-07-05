require 'rake_util'
require 'ostruct'

include RakeUtil

PRODUCTION_SERVER = 'lch1'

namespace :data do

  def dbenv(attr)
    env = Rails.configuration.database_configuration
    env[Rails.env][attr]
  end

  def backup_params
    {
      'db' => {
        :trans   => 'db/data.psql'        ,
        :targets => 'db/backups/data.psql',
        :copies  => 30 },
      'keys' => {
        :trans   => ''        ,
        :targets => %w(.env .certs),
        :copies  => 10 },
      'sysdir' => {
        :trans   => ''             ,
        :targets => 'public/system',
        :copies  => 5 },
    }
  end

  def gen_backup_opts(dataset)
    opt = OpenStruct.new
    opt.dataset       = dataset
    opt.app           = 'lica'
    opt.host          = `hostname`.chomp
    opt.base_dir      = File.expand_path('~/var/backup')
    opt.time_stamp    = Time.now.strftime('%y%m%d_%H%M%S')
    opt.lbl_dir       = [opt.base_dir, opt.app, opt.host, dataset].join('/')
    opt.tgt_dir       = [opt.base_dir, opt.app, opt.host, dataset, opt.time_stamp].join('/')
    opt.targets       = Array(backup_params[dataset][:targets])
    opt.copies        = backup_params[dataset][:copies]
    opt.trans         = backup_params[dataset][:trans]
    opt.backup_cp_cmd = Proc.new do |data_path|
      base = data_path.split('/').last.gsub(/^\./,"_")
      "tar -chzf #{opt.tgt_dir}/#{base}.tgz #{data_path}"
    end
    opt
  end

  def backup(dataset)
    opts = gen_backup_opts(dataset)
    system "mkdir -p #{opts.tgt_dir}"

    # ----- copy each target -----
    puts "Backing up #{dataset}"
    opts.targets.each do |path|
      cmd = opts.backup_cp_cmd.call(path)
      puts cmd
      system cmd
    end

    # ----- delete old backups if they exceed the copy limit -----
    list = Dir.glob(opts.lbl_dir + '/*').sort.reverse
    list.each_with_index do |path, index|
      if index >= opts.copies
        puts   "Removing old backup: #{path}"
        system "rm -r #{path}"
      end
    end
  end

  namespace :db do

    desc 'Export Postgres Data'
    task :export do
      puts "Exporting to 'db/backups/data.psql'"
      verbose(false) do
        sh "mkdir -p db/backups"
        sh "PGPASSWORD=#{dbenv('password')} pg_dump -h localhost -U #{dbenv("username")} #{dbenv('database')} -f db/backups/data.psql"
      end
    end

    desc 'Import Postgres Data'
    task :import => ['db:drop', 'db:create'] do
      puts "importing from 'db/data.psql'"
      verbose(false) do
        sh "mkdir -p db/backups"
        cmd = "psql -U #{dbenv("username")} -d lica_#{Rails.env.to_s} -f db/backups/data.psql > /dev/null"
        puts cmd
        sh cmd
      end
    end

  end

  namespace :backup do

    desc 'Backup all Targets'
    task :all => [:db, :keys, :sysdir] do
      puts 'All targets backed up'
    end

    desc 'Backup System Directory'
    task :sysdir do
      backup('sysdir')
    end

    desc 'Backup Database'
    task :db => ['db:export'] do
      backup('db')
    end

    desc 'Backup Keys'
    task :keys do
      backup('keys')
    end
  end

  def gen_restore_opts(opts, server, snapshot)
    opts.restore_dir = [opts.base_dir, opts.app, server, opts.dataset].join('/')
    if snapshot == 'latest'
      opts.restore_src = Dir.glob(opts.restore_dir + '/*').sort.reverse.first
    else
      abort "Can not process snapshot (#{snapshot})"
    end
    opts.restore_cp_cmd = Proc.new do |data_path|
      target = data_path.split('/').last
      target_path = "#{opts.restore_src}/#{target}.tgz"
      abort "Target Path not found (#{target_path})" unless File.exist? target_path
      "tar -xf #{target_path}"
    end
    opts
  end

  def restore(target, server, snapshot)
    backup_opts  = gen_backup_opts(target)
    restore_opts = gen_restore_opts(backup_opts, server, snapshot)
    msg = snapshot == 'latest' ? "latest (#{restore_opts.restore_src})" : snapshot
    puts "Restoring #{target} from #{server}/#{msg}"

    # ----- restore each target -----
    trans = restore_opts.trans
    path  = Array(restore_opts.targets).first
    restore_cmd = restore_opts.restore_cp_cmd.call(path)
    prevent_overwrite_cmd = "mv #{path} #{path}.#{restore_opts.time_stamp}"
    trans_cmd = "mv #{trans} #{path}"
    puts   prevent_overwrite_cmd    if File.exist? path
    system prevent_overwrite_cmd  if File.exist? path
    puts restore_cmd
    system restore_cmd
    puts trans_cmd   if File.exist?(trans)
    system trans_cmd if File.exist?(trans)
  end

  # restore just copies the data files into place
  # to do a full restore of the database:
  # rake data:restore:all
  # rake db:drop
  # rake data:db:import
  #
  namespace :restore do

    desc 'Restore all Targets'
    task :all => [:db, :sysdir] do
      puts 'All targets restored'
    end

    desc "Restore Sysdir (SERVER=#{PRODUCTION_SERVER} SNAPSHOT=latest)"
    task :sysdir do
      server   = ENV['SERVER']   || PRODUCTION_SERVER
      snapshot = ENV['SNAPSHOT'] || 'latest'
      restore('sysdir', server, snapshot)
    end

    desc "Restore Database (SERVER=#{PRODUCTION_SERVER} SNAPSHOT=latest)"
    task :db do
      server   = ENV['SERVER']   || PRODUCTION_SERVER
      snapshot = ENV['SNAPSHOT'] || 'latest'
      restore('db', server, snapshot)
    end
  end
end
