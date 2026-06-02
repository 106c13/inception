#!/bin/sh
set -e

while ! mysqladmin ping -h"$WORDPRESS_DB_HOST" --silent; do
    sleep 1
done

while ! redis-cli -h redis ping; do
    echo "Waiting for Redis..."
    sleep 1
done

if [ ! -f /var/www/html/wp-config.php ]; then
    wp core download --path=/var/www/html --allow-root
    wp config create --path=/var/www/html \
        --dbname="$WORDPRESS_DB_NAME" \
        --dbuser="$WORDPRESS_DB_USER" \
        --dbpass="$WORDPRESS_DB_PASSWORD" \
        --dbhost="$WORDPRESS_DB_HOST" \
        --allow-root
    
    wp config set WP_REDIS_HOST "redis" --allow-root
    wp config set WP_REDIS_PORT "6379" --allow-root
    wp config set WP_CACHE_KEY_SALT "$DOMAIN" --allow-root
    
    wp plugin install redis-cache --activate --allow-root
    
    wp redis enable --allow-root
    
    wp core install --path=/var/www/html \
        --url="https://$DOMAIN" \
        --title="Inception with Redis Cache" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --allow-root
    
    wp user create --path=/var/www/html \
        "$WP_USER" "$WP_USER_EMAIL" \
        --user_pass="$WP_USER_PASSWORD" \
        --role=author \
        --allow-root
fi

exec php-fpm8.2 -F
