#!/usr/bin/env bash

######
## Generate CA
######

# created a key to sign the certificates/csr's with
openssl genrsa -aes256 -passout pass:programic -out programic-CA.key 4096

# created a root CA CSR
openssl req -new -passin pass:programic -key programic-CA.key -out programic-CA.csr \
  -subj "/C=NL/ST=Overijssel/L=Deventer/O=Programic/OU=Development/CN=programic.com/emailAddress=development@programic.com"

# create a root CA certificate
openssl x509 -req -sha256 -passin pass:programic -days 365 -in programic-CA.csr -signkey programic-CA.key -out programic-CA.crt


######
## Generate *.pro.test cert
######
openssl genrsa -out pro.test.key 2048

# created a csr for the wildcard certificate
openssl req -new -key pro.test.key -out pro.test.csr \
  -subj "/C=NL/ST=Overijssel/L=Deventer/O=Programic/OU=Development/CN=pro.test/emailAddress=development@programic.com" \
  -addext 'subjectAltName=DNS:*.pro.test'

# created the self-signed wildcard
openssl x509 -req -sha256 -passin pass:programic -days 365 -in pro.test.csr -CA programic-CA.crt -CAkey programic-CA.key -CAcreateserial \
  -extfile <(printf "subjectAltName=DNS:*.pro.test") -out pro.test.crt

# created a certificate bundle
cat pro.test.crt programic-CA.crt > pro.test-bundle.crt