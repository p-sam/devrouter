FROM alpine:3.7

RUN apk add --no-cache dnsmasq

EXPOSE 53/udp
WORKDIR /srv

COPY ./docker/dns/app.sh /usr/bin/docker-run-app
RUN chmod a+rx /usr/bin/docker-run-app

COPY ./builder/dns /srv/builder
RUN chmod a+rx /srv/builder/build.sh


CMD ["/usr/bin/docker-run-app"]