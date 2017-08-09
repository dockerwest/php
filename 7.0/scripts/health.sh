#!/bin/bash

if [[ -e /.checkfpm ]]; then
    SCRIPT_NAME=/ping SCRIPT_FILENAME=/ping REQUEST_METHOD=GET \
        cgi-fcgi -bind -connect 127.0.0.1:9000 > /dev/null 2>&1
    exit $?
else
    exit 0
fi
