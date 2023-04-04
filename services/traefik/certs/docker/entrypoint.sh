#!/usr/bin/env bash

######
## Enter all wildcard certificates that need to be created
######

certificates=(
  pro.test
  auto.test
  kenniss.test
)

######
## Generate CA
######

echo -e "Generate CA"

# created a key to sign the certificates/csr's with
openssl genrsa -aes256 -passout pass:programic -out programic-ca.key 4096

# created a root CA CSR
openssl req -new -passin pass:programic -key programic-ca.key -out programic-ca.csr \
  -subj "/C=NL/ST=Overijssel/L=Deventer/O=Programic/OU=Development/CN=programic.com/emailAddress=development@programic.com"

# create a root CA certificate
openssl x509 -req -sha256 -passin pass:programic -days 365 -in programic-ca.csr -signkey programic-ca.key -out programic-ca.crt

######
## Generate certificates
######

for certificate in "${certificates[@]}"
do
  echo -e "\nGenerate ${certificate}..."

  openssl genrsa -out ${certificate}.key 2048

  # created a csr for the wildcard certificate
  openssl req -new -key ${certificate}.key -out ${certificate}.csr \
    -subj "/C=NL/ST=Overijssel/L=Deventer/O=Programic/OU=Development/CN=${certificate}/emailAddress=development@programic.com" \
    -addext "subjectAltName=DNS:*.${certificate}"

  # created the self-signed wildcard
  openssl x509 -req -sha256 -passin pass:programic -days 365 -in ${certificate}.csr -CA programic-ca.crt -CAkey programic-ca.key -CAcreateserial \
    -extfile <(printf "subjectAltName=DNS:*.${certificate}") -out ${certificate}.crt

  # created a certificate bundle
  cat ${certificate}.crt programic-ca.crt > ${certificate}-bundle.crt
done