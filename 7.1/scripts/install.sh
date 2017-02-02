#!/bin/sh

set -e

# ondrej debian
apt-get update
apt-get install -y apt-transport-https lsb-release ca-certificates curl
curl -o /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

# install packages
apt-get update
apt-get upgrade -y
apt-get install -y php7.1-cli php7.1-fpm php7.1-curl php7.1-json
apt-get clean -y
mkdir -p /var/www/app

# enable custom php configuration
phpenmod custom

# configure php for docker
sed -e 's#^\(error_log\).*#\1 = /dev/stderr#' \
    -e 's#^;\(daemonize\).*#\1 = no#' \
    -i /etc/php/7.1/fpm/php-fpm.conf
sed -e 's#^;\(access.log\).*#\1 = /dev/stderr#' \
    -e 's#^\(listen\).*#\1 = 0.0.0.0:9000#' \
    -e 's#^;\(catch_workers_output\).*#\1 = yes#' \
    -e 's#^;\(clear_env\).*#\1 = no#' \
    -i /etc/php/7.1/fpm/pool.d/www.conf

# install developer stuff
./install-development.sh

# gosu
GOSU_VERSION='1.10'
dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"
curl -L -o /usr/local/bin/gosu \
    "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"
chmod +x /usr/local/bin/gosu

