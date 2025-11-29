#!/bin/bash
set -e

WEBROOT="/var/www/html"
WPDIR="$WEBROOT/wordpress"

if [ ! -d "$WPDIR" ]; then
  mkdir -p $WEBROOT
  cd $WEBROOT
  curl -s -O https://wordpress.org/latest.tar.gz
  tar -xzf latest.tar.gz
  rm latest.tar.gz
  chown -R www-data:www-data $WPDIR
fi

if [ ! -f "$WPDIR/wp-config.php" ]; then
    cp $WPDIR/wp-config-sample.php $WPDIR/wp-config.php

    sed -i "s/database_name_here/${WORDPRESS_DB_NAME}/" $WPDIR/wp-config.php
    sed -i "s/username_here/${WORDPRESS_DB_USER}/" $WPDIR/wp-config.php
    sed -i "s/password_here/${WORDPRESS_DB_PASSWORD}/" $WPDIR/wp-config.php
    sed -i "s/localhost/${WORDPRESS_DB_HOST}/" $WPDIR/wp-config.php

    echo "wp-config.php successfully configured."
fi

sed -i 's|listen = .*|listen = 0.0.0.0:9000|' /etc/php/*/fpm/pool.d/www.conf

php-fpm8.4 -F
