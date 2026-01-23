#!/bin/bash

KEY_SIZE=4096
CA_KEY=/etc/ssl/private/rootCA.key
CA_PEM=/etc/ssl/private/rootCA.pem
KEY_TTL=365
KEY_BASE_NAME=$1

die () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -eq 1 ] || die "Usage: $0 <new cert base name>"

openssl genrsa -out ${KEY_BASE_NAME}.key ${KEY_SIZE}
openssl req -new -key ${KEY_BASE_NAME}.key -out ${KEY_BASE_NAME}.csr
openssl x509 -req -in ${KEY_BASE_NAME}.csr\
	-CA ${CA_PEM} -CAkey ${CA_KEY} -CAcreateserial \
	-out ${KEY_BASE_NAME}.crt -days ${KEY_TTL}

