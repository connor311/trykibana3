#!/bin/bash
export rvmsudo_secure_path=1

sudo apt-get update -qq
sudo apt-get install -y -qq make

## REDIS
cd ~
wget -q http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
cd redis-stable
make
sudo make install
sudo mkdir /etc/redis
sudo mkdir /var/redis
sudo cp utils/redis_init_script /etc/init.d/redis_6379
sudo cp redis.conf /etc/redis/6379.conf
sudo mkdir /var/redis/6379
sudo update-rc.d redis_6379 defaults

## ELASTICSEARCH
sudo apt-get install -y -qq openjdk-7-jre
cd ~
wget -q https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.2.deb
sudo dpkg -i elasticsearch-0.90.2.deb
rm elasticsearch-0.90.2.deb

## LOGSTASH
sudo mkdir /etc/logstash
cd /etc/logstash
sudo wget https://logstash.objects.dreamhost.com/release/logstash-1.1.13-flatjar.jar -O logstash.jar
sudo mkdir /var/log/logstash
sudo cp /home/vagrant/configs/logstash.conf /etc/logstash/logstash.conf
sudo cp /home/vagrant/configs/logstash /etc/init.d/logstash
sudo chmod +x /etc/init.d/logstash
sudo update-rc.d logstash defaults

## KIBANA
sudo apt-get install -y -qq curl
cd /home/vagrant
curl -s -L get.rvm.io | bash -s stable
if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then
  source "$HOME/.rvm/scripts/rvm"
elif [[ -s "/usr/local/rvm/scripts/rvm" ]] ; then
  source "/usr/local/rvm/scripts/rvm"
else
  printf "ERROR: An RVM installation was not found.\n"
  exit -1
fi
rvm reload
rvm requirements
rvmsudo /usr/bin/apt-get install -qq build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion libcurl4-openssl-dev
rvm install --quiet-curl 1.9.3
rvm use 1.9.3 --default
rvm rubygems current
gem install rails
gem install passenger
rvmsudo passenger-install-nginx-module --auto --prefix=/opt/nginx --auto-download
sudo apt-get install -y -qq git
cd /srv
sudo git clone https://github.com/elasticsearch/kibana.git
cd kibana

## NGINX
sudo cp /home/vagrant/configs/nginx.conf /opt/nginx/conf/nginx.conf
sudo cp /home/vagrant/configs/nginx /etc/init.d/nginx
sudo chmod +x /etc/init.d/nginx
sudo /usr/sbin/update-rc.d -f nginx defaults

sudo service redis_6379 start &
sudo service elasticsearch start &
sudo service logstash start &
sudo service nginx start &