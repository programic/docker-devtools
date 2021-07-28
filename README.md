# Docker local development environment

## To get started

1. Clone the [repository](https://bitbucket.org/programic/docker-devtools).
   ```bash
   git clone https://bitbucket.org/programic/docker-devtools
   cd docker-devtools
   ```
3. Create external networks
   ```bash
   docker network create web
   docker network create mailhog
   ```
3. Start dev-tools:
   ```bash
   docker-compose up -d
   ```

### Trust the self-signed CA SSL certificate

1. Add it to your MacOS Keychain:
   ```bash
   sudo security add-trusted-cert -d -r trustRoot -k "/Library/Keychains/System.keychain" \
     ./services/traefik/certs/programic-CA.crt
   ```
2. Browser support:
   * Chrome: out of the box
   * Safari: out of the box
   * Firefox:
      * `about:config` > `security.enterprise_roots.enabled`: `true`
3. Other support:
   * curl: out of the box
   * Postman:
     * `Postman` > `Preference` > `Certificates`
       * CA Certificates: `ON`
       * PEM file: `./services/traefik/certs/programic-CA.pem`

## Access services

1. Traefik:
   - Web interface: [http://localhost:8080](http://localhost:8080)
2. Portainer: 
   - Web interface: [http://localhost:9000](http://localhost:9000)
3. Mailhog: 
   - Web interface: [http://localhost:8025](http://localhost:8025)
   - SMTP: `mailhog:1025`
    
## How to creating a new tls certificate

How the self-signed root CA was created:
```bash
# install and use openssl, since MacOS comes with a very old LibreSSL
brew install openssl
ln -s /usr/local/Cellar/openssl@1.1/1.1.1k/bin/openssl /usr/local/bin/openssl

# created a key to sign the certificates/csr's with
openssl genrsa -aes256 -passout pass:programic -out programic-CA.key 4096

# created a root CA CSR
openssl req -new -key programic-CA.key -out programic-CA.csr \
  -subj "/C=NL/ST=Overijssel/L=Deventer/O=Programic/OU=Development/CN=programic.com/emailAddress=development@programic.com"

# check the csr
openssl req -text -noout -verify -in programic-CA.csr

# created a root CA certificate
openssl x509 -req -sha256 -days 365 -in programic-CA.csr -signkey programic-CA.key -out programic-CA.crt

# added the self-signed root CA certificate to the MacOS keychain 
sudo security add-trusted-cert -d -r trustRoot -k "/Library/Keychains/System.keychain" ./programic-CA.crt
```

Then, a self-signed wildcard certificate was created:
```bash
# created a key to sign the certificates/csr's with
openssl genrsa -out pro.test.key 2048

# created a csr for the wildcard certificate
openssl req -new -key pro.test.key -out pro.test.csr \
  -subj "/C=NL/ST=Overijssel/L=Deventer/O=Programic/OU=Development/CN=pro.test/emailAddress=development@programic.com" \
  -addext 'subjectAltName=DNS:*.pro.test'

# check the csr
openssl req -text -noout -verify -in pro.test.csr

# created the self-signed wildcard
openssl x509 -req -sha256 -days 365 -in pro.test.csr \
  -CA programic-CA.crt -CAkey programic-CA.key -CAcreateserial \
  -extfile <(printf "subjectAltName=DNS:*.pro.test") \
  -out pro.test.crt

# checked the certificate
openssl x509 -text -noout -in pro.test.crt

# created a certificate bundle
cat pro.test.crt programic-CA.crt > pro.test-bundle.crt

# checked the bundle
openssl crl2pkcs7 -nocrl -certfile pro.test-bundle.crt| openssl pkcs7 -print_certs -noout
```
