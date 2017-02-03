#!/bin/bash

if [ ! -z $C_GID ]; then
    groupmod -g $C_GID www-data
fi

if [ ! -z $C_UID ]; then
    usermod -u $C_UID www-data
fi


mkdir /run/php
chown www-data:www-data /run/php
chown www-data:www-data /var/www/app

if [[ ! -z $DEVELOPMENT ]]; then
    if [[ "noprofile" != "$DEVELOPMENT" ]]; then
        mkdir -p /var/www/xhprof
        chown www-data:www-data /var/www/xhprof
        phpenmod tideways > /dev/null 2>&1
    fi

    phpenmod development > /dev/null 2>&1
    phpenmod xdebug > /dev/null 2>&1

    ln -s /usr/local/lib/composer /usr/local/bin/composer
fi

