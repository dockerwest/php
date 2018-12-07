FROM debian:stretch-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV DW_PHP_VERSION=7.3

COPY ./scripts /
RUN /install.sh && rm /install*

EXPOSE 9000
VOLUME ["/xhprof", "/xdebug"]
WORKDIR /phpapp

ENTRYPOINT ["/command.sh"]
CMD ["php-fpm7.3"]

HEALTHCHECK --interval=10s --timeout=3s CMD /health.sh
