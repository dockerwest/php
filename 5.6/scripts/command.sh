#!/bin/bash

if [ "php-fpm5.6" == "$1" ]; then
    touch /.checkfpm
fi

/prepare.sh

if [ "php-fpm5.6" != "$1" ] && [ "/bin/bash" != "$1" ]; then
    exec gosu www-data "$@"
else
    exec "$@"
fi
