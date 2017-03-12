# WARNING - TEST whenever this file is
# changed, or `foreman` is upgraded.

web: bin/puma -p $PORT -C config/puma.rb -S $USR_HOME/.LICA_Puma_State
#sidekiq: bin/sidekiq --daemon -C config/sidekiq.yml
# statsite: statsite -f config/statsite.ini

# Nginx Note:
# auto-started by SystemD
# configured by apt-get install
# (sudo apt-get install nginx)
# see /etc/init.d/nginx
#
# Postgres Note:
# auto-started by SystemD
# configured by apt-get install
# (sudo apt-get install postgresql)
# see /etc/init.d/postgresql
#
# Memcached Notes:
# auto-started by SystemD
# configured by apt-get install
# (sudo apt-get install memcached)
# see /etc/init.d/memcached
#
# Redis Note:
# auto-started by SystemD
# configured by apt-get install
# (sudo apt-get install redis-server)
# see /etc/init.d/redis-server
#
# InfluxDB Note:
# auto-started by SystemD
# configured by apt-get install
# (sudo apt-get install influxdb)
# see /etc/init.d/influxdb

