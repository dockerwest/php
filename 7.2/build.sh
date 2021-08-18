#!/usr/bin/env sh
#docker pull debian:buster-slim

docker build --no-cache -t dockerwest/php:7.2 .
