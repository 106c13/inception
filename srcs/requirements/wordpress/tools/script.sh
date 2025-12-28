#!/bin/bash
set -e

WEBROOT="/var/www/html"
WPDIR="$WEBROOT/wordpress"

if [ ! -d "$WPDIR" ]; then
  mkdir -p "$WEBROOT"
  cd "$WEBROOT"
  echo "Downloading WordPress..."
  curl -s -O https://wordpress.org/latest.tar.gz
  echo "Extracting WordPress..."
  tar -xzf latest.tar.gz
  rm latest.tar.gz
  echo "Checking contents of $WEBROOT:"
  ls -l "$WEBROOT"
  echo "Changing ownership..."
  chown -R www-data:www-data "$WPDIR"
fi

cp "$WPDIR/wp-config-sample.php" "$WPDIR/wp-config.php"


sed -i "s/database_name_here/${WORDPRESS_DB_NAME}/" "$WPDIR/wp-config.php"
sed -i "s/username_here/${WORDPRESS_DB_USER}/" "$WPDIR/wp-config.php"
sed -i "s/password_here/${WORDPRESS_DB_PASSWORD}/" "$WPDIR/wp-config.php"
sed -i "s/localhost/${WORDPRESS_DB_HOST}/" "$WPDIR/wp-config.php"

wp core install \
  --url="https://${DOMAIN}" \
  --title="Inception" \
  --admin_user="$WP_ADMIN_USER" \
  --admin_password="$WP_ADMIN_PASSWORD" \
  --admin_email="$WP_ADMIN_EMAIL" \
  --path="$WPDIR" \
  --allow-root

wp user create \
  "$WP_USER" "$WP_USER_EMAIL" \
  --role=subscriber \
  --user_pass="$WP_USER_PASSWORD" \
  --path="$WPDIR" \
  --allow-root

echo "WordPress installed and configured successfully."

sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php/8.2/fpm/pool.d/www.conf

exec php-fpm8.2 -F
