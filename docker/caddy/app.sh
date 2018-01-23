#!/bin/sh
echo "[!] Building config"
cd builder && npm start || exit $?

echo "[!] Running Caddy"
CASE_SENSITIVE_PATH=1 exec /usr/bin/caddy -conf /srv/caddy/Caddyfile -log stderr