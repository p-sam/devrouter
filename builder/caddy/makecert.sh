#!/bin/sh

set -e

DOMAIN=$1
CERT_DIR="/srv/caddy/cert"

mkdir -p "$CERT_DIR";

if [ ! -f "$CERT_DIR/_ca.key" ]; then
    echo "* generating CA private key"
    openssl genrsa -out "$CERT_DIR/_ca.key" 2048 
fi

if [ ! -f "$CERT_DIR/_ca.pem" ]; then
    echo "* generating CA root cert"
    openssl req -x509 -new -nodes -key "$CERT_DIR/_ca.key" -subj "/C=US/ST=Nevada/L=Las Vegas/O=devrouter/CN=devrouter CA" -sha256 -days 36500 -out "$CERT_DIR/_ca.pem"
fi

if [ ! -f "$CERT_DIR/$DOMAIN.key" ]; then
    echo "* generating $DOMAIN private key"
    openssl genrsa -out "$CERT_DIR/$DOMAIN.key" 2048
fi

if [ ! -f "$CERT_DIR/$DOMAIN.key" ]; then
    echo "* generating $DOMAIN private key"
    openssl genrsa -out "$CERT_DIR/$DOMAIN.key" 2048
fi

if [ ! -f "$CERT_DIR/$DOMAIN.csr" ]; then
    echo "* generating $DOMAIN cert request"
    openssl req -new -key "$CERT_DIR/$DOMAIN.key" \
        -out "$CERT_DIR/$DOMAIN.csr" \
        -subj "/C=US/ST=Nevada/L=Las Vegas/O=devrouter/CN=$DOMAIN"
fi

if [ ! -f "$CERT_DIR/$DOMAIN.ext" ]; then
tee "$CERT_DIR/$DOMAIN.ext" <<EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = $DOMAIN
EOF
fi

if [ ! -f "$CERT_DIR/$DOMAIN.pem" ]; then
    echo "* generating $DOMAIN cert from request"
    openssl x509 -req -in "$CERT_DIR/$DOMAIN.csr" -CA "$CERT_DIR/_ca.pem" -CAkey "$CERT_DIR/_ca.key" -CAcreateserial \
        -out "$CERT_DIR/$DOMAIN.pem" -days 36500 -sha256 -extfile "$CERT_DIR/$DOMAIN.ext"
fi