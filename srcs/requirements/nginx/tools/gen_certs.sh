#!/bin/sh

# SHOULD BE RAN FROM THE MAKEFILE BEFORE DOCKER COMPOSE

set -a
. ../../../.env
set +a

CERT_DIR="ssl"

mkdir -p "$CERT_DIR"

openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout "$CERT_DIR/nginx.key" \
  -out "$CERT_DIR/nginx.crt" \
  -subj "/CN=$DOMAIN_NAME"

echo "✅ Certificate and key generated for $DOMAIN_NAME in $CERT_DIR"