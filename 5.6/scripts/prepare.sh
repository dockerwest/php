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

if [[ "1" == "$DEVELOPMENT" ]]; then
    if [[ ! -z $PHP_EXTRA_MODULES ]]; then
        /usr/local/bin/extensions -i $PHP_EXTRA_MODULES
    fi

    sed -e 's/^\(opcache\.validate_timestamps=\).*/\11/g' \
        -i /etc/php/5.6/mods-available/opcache_settings.ini

    phpenmod development > /dev/null 2>&1
    phpenmod xdebug > /dev/null 2>&1

    ln -s /usr/local/lib/composer /usr/local/bin/composer
fi

if [[ "xdebug" == "$PROFILER" ]]; then
    mkdir -p /xdebug
    chown www-data:www-data /xdebug
    phpenmod xdebug > /dev/null 2>&1
    phpenmod xdebug_profiler > /dev/null 2>&1
elif [[ "xhprof" == "$PROFILER" ]]; then
    mkdir -p /xhprof
    chown www-data:www-data /xhprof
    phpenmod xhprof > /dev/null 2>&1
fi
