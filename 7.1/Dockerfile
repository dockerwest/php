FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

COPY ./scripts /
RUN /install.sh && rm /install*

EXPOSE 9000
VOLUME ["/var/www/app", "/var/www/xhprof"]
WORKDIR /var/www/app

ENTRYPOINT ["/command.sh"]
CMD ["php-fpm7.1"]
