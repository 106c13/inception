#!/bin/bash

mkdir -p /etc/nginx/ssl

openssl req -x509 -nodes -newkey rsa:2048 \
  -keyout /etc/nginx/ssl/server.key \
  -out /etc/nginx/ssl/server.crt \
  -subj "/CN=haaghaja.42.fr" \
  -days 365

echo `date` "Nginx is running";
nginx -g "daemon off;"
