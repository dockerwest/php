#!/bin/bash

set -e

curl -LsS https://packagecloud.io/gpg.key | apt-key add -
echo "deb http://packages.blackfire.io/debian any main" > /etc/apt/sources.list.d/blackfire.list

apt-get update
apt-get install -y php-xdebug php-tideways git blackfire-php
apt-get clean -y
curl -LsS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/local/lib --filename=composer
[[ -e /usr/local/lib/composer ]] || false && true

(
    cd /usr/lib/php/$(php -i | grep ^extension_dir | sed -e 's/.*\/\([0-9]*\).*/\1/')
    curl -O https://raw.githubusercontent.com/tideways/profiler/master/Tideways.php
    [[ -e Tideways.php ]] || false && true
)

curl -LsSO "https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64"
mv mhsendmail_linux_amd64 /usr/local/lib/mhsendmail
chmod +x /usr/local/lib/mhsendmail

printf "xdebug.remote_enable = 1\nxdebug.remote_connect_back = 1\nxdebug.max_nesting_level=400\n" \
    >> /etc/php/${DW_PHP_VERSION}/mods-available/xdebug.ini

if [[ -e /etc/php/${DW_PHP_VERSION}/mods-available/tideways.ini ]]; then
    cp -a /etc/php/${DW_PHP_VERSION}/mods-available/tideways.ini \
        /etc/php/${DW_PHP_VERSION}/mods-available/xhprof.ini

    printf "auto_prepend_file=/usr/share/xhprof/prepend.php\n" \
        >> /etc/php/${DW_PHP_VERSION}/mods-available/xhprof.ini

    printf "tideways.udp_connection=\"tideways:8135\"\ntideways.connection=\"tcp://tideways:9135\"\ntideways.monitor_cli=1\n" \
        >> /etc/php/${DW_PHP_VERSION}/mods-available/tideways.ini
    printf "auto_prepend_file=/usr/share/tideways/prepend.php\n" \
        >> /etc/php/${DW_PHP_VERSION}/mods-available/tideways.ini
fi

if [[ -e /etc/php/${DW_PHP_VERSION}/mods-available/blackfire.ini ]]; then
    sed -e 's#\(blackfire.agent_socket\).*#\1=tcp://blackfire:8707#' \
        -i /etc/php/${DW_PHP_VERSION}/mods-available/blackfire.ini
fi

phpdismod xdebug
phpdismod tideways
phpdismod blackfire
