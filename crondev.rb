# Use this file to define cron jobs on your development system.
#
# to generate cronfile : `whenever -f crondev.rb --update-crontab`
# to clear cronfile    : `whenever -f crondev.rb --clear-crontab`
# for help on whenever : `whenever -h`
# to see cron settings : `crontab -l`
# to edit the cronfile : `crontab -e`
#
# Learn more:
# - http://github.com/javan/whenever  | cron processor
# - http://en.wikipedia.org/wiki/Cron | cron instructions

set :output, "/tmp/cron_Lica.log"

every 1.day, at: "3:00 am" do
  script  "cron/backup.sh"
end

