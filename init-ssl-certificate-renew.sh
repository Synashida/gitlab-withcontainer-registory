#!/bin/bash

#
# gitlab.example.com.crtとgitlab.example.com.keyをSANs付き証明書に更新する
#

echo "down docker-compose"
docker-compose down
echo "start docker-compose"
docker-compose up web -d
sleep 15
echo "renew ssl certificate"
docker-compose exec web /bin/bash -c "cd /etc/gitlab/ssl && cp gitlab.example.com.crt gitlab.example.com.crt.org && cp gitlab.example.com.key gitlab.example.com.key.org && openssl req -newkey rsa:4096 -days 3650 -nodes -x509 -subj \"/C=JP/ST=CHIBA/L=CHIBA/O=NAN/OU=NAN/CN=gitlab.example.com\" -extensions v3_ca -config <(cat /opt/gitlab/embedded/ssl/openssl.cnf <(printf \"[v3_ca]\\nsubjectAltName='DNS:*.example.com,IP:173.0.0.10'\") ) -keyout gitlab.example.com.key -out gitlab.example.com.crt"
docker-compose down
sleep 15
docker-compose up -d
