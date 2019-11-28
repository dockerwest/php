#!/usr/bin/env sh
#docker pull debian:stable-slim

docker build --no-cache -t dockerwest/php:7.1 .
