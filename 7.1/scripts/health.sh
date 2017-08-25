#!/bin/bash

if [[ -e /.checkfpm ]]; then
    php-health.phar
    exit $?
else
    exit 0
fi
