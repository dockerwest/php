#!/usr/bin/env sh
#docker pull debian:stable-slim

docker build --no-cache -t dockerwest/php:8.0 .
