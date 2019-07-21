#!/usr/bin/env sh
#docker pull debian:stretch-slim

docker build --squash=true --no-cache -t dockerwest/php:5.6 .
