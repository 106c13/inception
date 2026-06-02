#!/bin/sh
set -e

echo "Waiting for WordPress to be ready..."
while ! nc -z wordpress 9000; do
    echo "Waiting for wordpress:9000..."
    sleep 2
done

echo "WordPress is ready!"

if [ ! -f /etc/nginx/ssl/haaghaja.42.fr.crt ]; then
    echo "Generating SSL certificate..."
    mkdir -p /etc/nginx/ssl
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/haaghaja.42.fr.key \
        -out /etc/nginx/ssl/haaghaja.42.fr.crt \
        -subj "/C=FR/ST=Paris/L=Paris/O=42/OU=Inception/CN=haaghaja.42.fr"
    echo "SSL certificate generated"
fi

echo "Starting Nginx..."

exec nginx -g "daemon off;"
