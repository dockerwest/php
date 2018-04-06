#!/bin/bash

if [[ -e /.checkfpm ]]; then
    php -n /usr/local/bin/php-health.phar
    exit $?
else
    exit 0
fi
