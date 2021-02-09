#!/bin/bash -e

# General configuration

RUBY_VERSION=2.6.6
ELASTICSEARCH_VERSION=7.9.3

function debian_basics {
  apt-get update
  apt-get install -y \
    build-essential libxml2-dev libxslt-dev libssl-dev git-core \
    libreadline-dev zlib1g-dev mariadb-server default-libmysqlclient-dev \
    libpq-dev apt-transport-https curl htop default-jre net-tools \
    chromium-driver pwgen zip libsqlite3-dev

  # https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html
  echo vm.max_map_count=262144 > /etc/sysctl.d/vm_max_map_count.conf
  sysctl --system

  # configure mysql to listen on all interfaces and allow connections
  sed -i -E "s/bind-address\s*=\s*127.0.0.1/#bind-address = 127.0.0.1/" /etc/mysql/mariadb.conf.d/50-server.cnf
  systemctl restart mariadb
  mysql -e "UPDATE mysql.user SET Host='%', Plugin='', Password=PASSWORD('root') WHERE User LIKE 'root'"
  mysql -e "FLUSH PRIVILEGES"

  # elasticsearch (development & test)
  useradd -m elasticsearch
  mkdir /opt/elastic
  cd /opt/elastic
  wget -O elastic.tar.gz "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$ELASTICSEARCH_VERSION-linux-x86_64.tar.gz"
  mkdir elasticsearch
  tar xzf elastic.tar.gz --directory elasticsearch --strip-components=1
  rm elastic.tar.gz

  mv elasticsearch development
  sed -i -E "/^#\s*?node.name:.*$/a node.name: node-1" development/config/elasticsearch.yml
  sed -i -E "/^#\s*?network.host:.*$/a network.host: 0.0.0.0" development/config/elasticsearch.yml
  sed -i -E "/^#\s*?http.port:.*$/a transport.port: 9300-9349" development/config/elasticsearch.yml
  sed -i -E "/^#\s*?discovery.seed_hosts:.*$/a discovery.seed_hosts: [\"0.0.0.0:9300\"]" development/config/elasticsearch.yml
  sed -i -E "/^#\s*?cluster.initial_master_nodes:.*$/a cluster.initial_master_nodes: [\"node-1\"]" development/config/elasticsearch.yml
  chown -R elasticsearch. development

  cp /vagrant/deploy/elasticsearch-development.service /etc/systemd/system/
  systemctl daemon-reload

  systemctl enable elasticsearch-development.service

  # unknown why this is needed
  rm -f /opt/elastic/development/config/elasticsearch.keystore.tmp

  systemctl start elasticsearch-development
}

function install_rbenv {
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
  echo 'export PATH="~/.rbenv/bin:$PATH"' >> ~/.bash_profile
  echo 'export PATH="~/.rbenv/shims:$PATH"' >> ~/.bash_profile
  source ~/.bash_profile

  rbenv install $RUBY_VERSION
  rbenv global $RUBY_VERSION

  # install both versions of bundler
  gem install bundler -v '< 2'
  gem install bundler -v '>= 2'
}

$1
