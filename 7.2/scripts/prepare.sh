#!/bin/bash

if [ ! -z $C_GID ]; then
    groupmod -g $C_GID www-data
fi

if [ ! -z $C_UID ]; then
    usermod -u $C_UID www-data
fi

if [ ! -d /run/php ]; then
    mkdir /run/php
fi
chown www-data:www-data /run/php

if [ ! -d /var/www ]; then
    mkdir /var/www
fi
chown www-data:www-data /var/www

chown www-data:www-data /phpapp

if [[ ! -z $DEVELOPMENT ]]; then
    sed -e 's/^\(opcache\.validate_timestamps=\).*/\11/g' \
        -i /etc/php/7.2/mods-available/opcache_settings.ini

    if [[ "noprofile" != "$DEVELOPMENT" ]]; then
        mkdir -p /xhprof
        chown www-data:www-data /xhprof
        phpenmod tideways > /dev/null 2>&1
    fi

    phpenmod development > /dev/null 2>&1
    phpenmod xdebug > /dev/null 2>&1

    ln -s /usr/local/lib/composer /usr/local/bin/composer
fi

