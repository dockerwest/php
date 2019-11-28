#!/bin/bash

if [[ 0 = "$UID" ]]; then
    if [[ ! -z $C_GID ]]; then
        groupmod -g $C_GID www-data
    fi

    if [[ ! -z $C_UID ]]; then
        usermod -u $C_UID www-data
    fi

    chown www-data:www-data /run/php

    chown www-data:www-data /var/www

    chown www-data:www-data /phpapp
fi

if [[ "1" == "$DEVELOPMENT" ]]; then
    if [[ 0 = "$UID" ]] && [[ ! -z $PHP_EXTRA_MODULES ]]; then
        /usr/local/bin/extensions -i $PHP_EXTRA_MODULES
    fi

    sed -e 's/^\(opcache\.validate_timestamps=\).*/\11/g' \
        -i /etc/php/${DW_PHP_VERSION}/mods-available/opcache_settings.ini

    phpenmod development > /dev/null 2>&1
    phpenmod xdebug > /dev/null 2>&1

    ln -s /usr/local/lib/composer /usr/local/bin/composer
fi

if [[ "1" != "$DEVELOPMENT" ]] && [[ -e /phpapp/preload.php ]]; then
    phpenmod opcache_preload
fi

if [[ "xdebug" == "$PROFILER" ]]; then
    [[ 0 = "$UID" ]] && chown www-data:www-data /xdebug
    phpenmod xdebug > /dev/null 2>&1
    phpenmod xdebug_profiler > /dev/null 2>&1
elif [[ "xhprof" == "$PROFILER" ]]; then
    [[ 0 = "$UID" ]] && chown www-data:www-data /xhprof
    phpenmod xhprof > /dev/null 2>&1
elif [[ "tideways" == "$PROFILER" ]]; then
    phpenmod tideways > /dev/null 2>&1
elif [[ "blackfire" == "$PROFILER" ]]; then
    phpenmod blackfire > /dev/null 2>&1
fi
