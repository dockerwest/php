#!/bin/sh
docker pull debian:stretch-slim

docker build --no-cache -t dockerwest/php:7.2 .
