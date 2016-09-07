FROM alpine:latest

RUN apk add --update \
    transmission-daemon \
    && rm -rf /var/cache/apk/*

RUN mkdir -p /transmission/downloads \
  && mkdir -p /transmission/incomplete \
  && mkdir -p /etc/transmission-daemon

COPY src/ .

VOLUME ["/transmission/downloads"]
VOLUME ["/transmission/incomplete"]

RUN mkdir /transmission/mem \
  && echo none /transmission/mem ramfs  defaults,size=2048M   0     0 >> /etc/fstab

EXPOSE 9091 51413/tcp 51413/udp

ENV USERNAME admin
ENV PASSWORD password

RUN chmod +x /start-transmission.sh
CMD ["/start-transmission.sh"]
