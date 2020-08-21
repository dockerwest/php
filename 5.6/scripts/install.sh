#!/bin/bash

set -e

# ondrej debian
apt-get update
apt-get install -y apt-transport-https lsb-release ca-certificates curl \
    liblz4-tool gnupg unzip
curl -o /etc/apt/trusted.gpg.d/php.gpg \
    https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" \
    > /etc/apt/sources.list.d/php.list

# install packages
apt-get update
apt-get upgrade -y
apt-get install -y php${DW_PHP_VERSION}-cli \
    php${DW_PHP_VERSION}-fpm \
    php${DW_PHP_VERSION}-curl \
    php${DW_PHP_VERSION}-json \
    php${DW_PHP_VERSION}-zip \
    php-apcu
update-alternatives --set php /usr/bin/php${DW_PHP_VERSION}
apt-get clean -y

mkdir -p /phpapp

# enable custom php configuration
phpenmod custom

# enable custom opcache config
phpenmod opcache_settings

# configure php for docker
sed -e 's#^\(error_log\).*#\1 = /dev/stderr#' \
    -e 's#^;\(daemonize\).*#\1 = no#' \
    -i /etc/php/${DW_PHP_VERSION}/fpm/php-fpm.conf
sed -e 's#^;\(access.log\).*#\1 = /dev/stderr#' \
    -e 's#^\(listen\).*#\1 = 0.0.0.0:9000#' \
    -e 's#^;\(catch_workers_output\).*#\1 = yes#' \
    -e 's#^;\(clear_env\).*#\1 = no#' \
    -e 's#^;\(ping\)#\1#g' \
    -i /etc/php/${DW_PHP_VERSION}/fpm/pool.d/www.conf

# install developer stuff
./install-development.sh

# gosu
GOSU_VERSION='1.10'
dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"
curl -L -o /usr/local/bin/gosu \
    "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"
chmod +x /usr/local/bin/gosu

# phphealth
PHP_HEALTH_VERSION='0.0.2'
curl -L -o /usr/local/bin/php-health.phar \
    "https://github.com/dockerwest/php-health/releases/download/$PHP_HEALTH_VERSION/php-health.phar"
chmod +x /usr/local/bin/php-health.phar

# update permissions to allow rootless operation
/usr/local/bin/permissions
