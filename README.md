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
4. Add the bin folder to your $PATH
   ```bash
   # Bash as shell
   nano ~/.bashrc 
   
   # ZSH as shell
   nano ~/.zshrc
   
   # Add this to the bottom of this file, and change the path to your docker-devtools folder
   export PATH="${PATH}:/Users/remco/code/docker-devtools/bin"
   ```

### Trust the self-signed CA SSL certificate
1. Add it to your MacOS Keychain:
   ```bash
   sudo security add-trusted-cert -d -r trustRoot -k "/Library/Keychains/System.keychain" ./services/traefik/certs/output/programic-CA.crt
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
       * PEM file: `./services/traefik/certs/output/programic-CA.pem`

### Installing the NrdSSH client (Alias `s`)
![NrdSSH client screenshot](readme-assets/nrdssh-client.png)

1. Installing the `dialog` package: Ubuntu `sudo apt install dialog`, MacOS `brew install dialog`
2. Open the NrdSSH client by running `s` in your terminal

## Access services
1. Traefik:
   - Web interface: [http://localhost:8080](http://localhost:8080)
2. Portainer: 
   - Web interface: [http://localhost:9000](http://localhost:9000)
3. Mailhog: 
   - Web interface: [http://localhost:8025](http://localhost:8025)
   - SMTP: `mailhog:1025`
    
## How to renew the Programic developer certificate?
1. First build the Docker image to generate the Programic developer certificates. Navigate to `cd services/traefik/certs/docker` and run `bash build.sh`
2. Navigate to its parent directory `cd ..` and run the Docker image you just build: `bash generate.sh`
3. Done. The certificates are saved in the `output` directory. Commit your changes.