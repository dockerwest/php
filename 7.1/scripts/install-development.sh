#!/bin/sh

set -e

apt-get update
apt-get install -y php-xdebug php-tideways git
apt-get clean -y
curl -LsS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/local/lib --filename=composer
[ -e /usr/local/lib/composer ] || false && true

(
    cd /usr/lib/php/$(php -i | grep ^extension_dir | sed -e 's/.*\/\([0-9]*\).*/\1/')
    curl -O https://raw.githubusercontent.com/tideways/profiler/master/Tideways.php
    [ -e Tideways.php ] || false && true
)

curl -LsSO "https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64"
mv mhsendmail_linux_amd64 /usr/local/lib/mhsendmail
chmod +x /usr/local/lib/mhsendmail

printf "xdebug.remote_enable = 1\nxdebug.remote_connect_back = 1\nxdebug.max_nesting_level=400\n" \
    >> /etc/php/7.1/mods-available/xdebug.ini

cp -a /etc/php/7.1/mods-available/tideways.ini \
    /etc/php/7.1/mods-available/xhprof.ini

printf "auto_prepend_file=/usr/share/xhprof/prepend.php\n" \
    >> /etc/php/7.1/mods-available/xhprof.ini

printf "tideways.udp_connection=\"tideways:8135\"\ntideways.connection=\"tcp://tideways:9135\"\ntideways.monitor_cli=1\n" \
    >> /etc/php/7.1/mods-available/tideways.ini
printf "auto_prepend_file=/usr/share/tideways/prepend.php\n" \
    >> /etc/php/7.1/mods-available/tideways.ini

phpdismod xdebug
phpdismod tideways

