#!/bin/sh
set -e

echo "Waiting for MariaDB..."
while ! mysqladmin ping -h"$WORDPRESS_DB_HOST" --silent; do
    sleep 1
done

echo "Configuring PHP-FPM to listen on port 9000..."
sed -i 's/listen = \/run\/php\/php8.2-fpm.sock/listen = 9000/' /etc/php/8.2/fpm/pool.d/www.conf
sed -i 's/;listen.allow_clients = 127.0.0.1/listen.allowed_clients = any/' /etc/php/8.2/fpm/pool.d/www.conf

echo "listen = 9000" >> /etc/php/8.2/fpm/pool.d/www.conf

if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Downloading WordPress..."
    wp core download --path=/var/www/html --allow-root
    
    echo "Creating wp-config.php..."
    wp config create --path=/var/www/html \
        --dbname="$WORDPRESS_DB_NAME" \
        --dbuser="$WORDPRESS_DB_USER" \
        --dbpass="$WORDPRESS_DB_PASSWORD" \
        --dbhost="$WORDPRESS_DB_HOST" \
        --allow-root
    
    echo "Installing WordPress..."
    wp core install --path=/var/www/html \
        --url="https://$DOMAIN" \
        --title="Inception" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --allow-root
    
    echo "Creating additional user..."
    wp user create --path=/var/www/html \
        "$WP_USER" "$WP_USER_EMAIL" \
        --user_pass="$WP_USER_PASSWORD" \
        --role=author \
        --allow-root
fi

chown -R www-data:www-data /var/www/html

echo "Starting PHP-FPM on port 9000..."

exec php-fpm8.2 -F
