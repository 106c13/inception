#!/bin/sh
set -e

# Wait for MariaDB
echo "Waiting for MariaDB..."
while ! mysqladmin ping -h"$WORDPRESS_DB_HOST" --silent; do
    sleep 2
done

echo "MariaDB is ready!"

# Wait for Redis
echo "Waiting for Redis..."
MAX_RETRIES=30
RETRY_COUNT=0
while ! redis-cli -h redis ping 2>/dev/null; do
    RETRY_COUNT=$((RETRY_COUNT + 1))
    if [ $RETRY_COUNT -ge $MAX_RETRIES ]; then
        echo "Redis not available after $MAX_RETRIES retries"
        exit 1
    fi
    echo "Waiting for Redis... (attempt $RETRY_COUNT/$MAX_RETRIES)"
    sleep 2
done

echo "Redis is available!"

# Configure PHP-FPM to listen on port 9000
echo "Configuring PHP-FPM to listen on port 9000..."
sed -i 's/listen = \/run\/php\/php8.2-fpm.sock/listen = 9000/' /etc/php/8.2/fpm/pool.d/www.conf
sed -i 's/;listen.allow_clients = 127.0.0.1/listen.allowed_clients = any/' /etc/php/8.2/fpm/pool.d/www.conf

# Download and configure WordPress if not already done
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
    
    echo "Configuring Redis..."
    wp config set WP_REDIS_HOST "redis" --allow-root --path=/var/www/html
    wp config set WP_REDIS_PORT "6379" --allow-root --path=/var/www/html
    wp config set WP_REDIS_DATABASE "0" --allow-root --path=/var/www/html
    wp config set WP_CACHE_KEY_SALT "$DOMAIN" --allow-root --path=/var/www/html
    
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
        --allow-root || true
    
    echo "Installing Redis plugin..."
    wp plugin install redis-cache --activate --allow-root --path=/var/www/html
    
    echo "Enabling Redis cache..."
    wp redis enable --allow-root --path=/var/www/html
fi

# Fix permissions
chown -R www-data:www-data /var/www/html

echo "Starting PHP-FPM on port 9000..."
exec php-fpm8.2 -F
