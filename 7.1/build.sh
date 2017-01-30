#!/bin/sh
docker pull debian:stable-slim

docker build --no-cache -t blackikeeagle/php-debian:7.1 .
