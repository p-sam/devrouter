#!/bin/sh

render_tpl()
{
    sed -e "s/%domain%/$DOMAIN/g" -e "s/%dns_port%/$DNS_PORT/g" "/srv/builder/$1.tpl" > "/srv/dns/$1"
    return $?
}

render_tpl "dnsmasq.conf" || exit $?
render_tpl "domain_resolver" || exit $?