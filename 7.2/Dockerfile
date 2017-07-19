FROM debian:stretch-slim

ENV DEBIAN_FRONTEND=noninteractive

COPY ./scripts /
RUN /install.sh && rm /install*

EXPOSE 9000
VOLUME ["/xhprof"]
WORKDIR /phpapp

ENTRYPOINT ["/command.sh"]
CMD ["php-fpm7.2"]
