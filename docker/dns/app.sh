#!/bin/sh

if [[ -z "$DOMAIN" ]]; then
    echo "No domain configured. Exiting..." 1>&2
    exit 1
fi

echo "[!] Building config"
/srv/builder/build.sh || exit $?

echo "[!] Running DnsMasq"
exec dnsmasq --keep-in-foreground --log-facility=- --conf-file=/srv/dns/dnsmasq.conf