FROM debian:buster-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV DW_PHP_VERSION=8.0

COPY ./scripts /
RUN /install.sh && rm /install*

EXPOSE 9000
VOLUME ["/xhprof", "/xdebug"]
WORKDIR /phpapp

ENTRYPOINT ["/command.sh"]
CMD ["php-fpm8.0"]

HEALTHCHECK --interval=10s --timeout=3s CMD /health.sh
