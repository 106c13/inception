#!/bin/sh
set -e

# Create required directories
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# Initialize database if not exists
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB database..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Start MariaDB temporarily without password
echo "Starting MariaDB temporarily..."
mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking --skip-grant-tables &
pid="$!"

# Wait for socket
echo "Waiting for socket..."
while [ ! -S /run/mysqld/mysqld.sock ]; do
    sleep 1
done

echo "Configuring MariaDB..."

# Set root password and create database
mysql -u root --socket=/run/mysqld/mysqld.sock <<EOF
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${WORDPRESS_DB_NAME};
CREATE USER IF NOT EXISTS '${WORDPRESS_DB_USER}'@'%' IDENTIFIED BY '${WORDPRESS_DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${WORDPRESS_DB_NAME}.* TO '${WORDPRESS_DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

# Kill temporary instance
kill "$pid"
wait "$pid" 2>/dev/null || true

echo "MariaDB setup complete. Starting MariaDB..."

# Start MariaDB in foreground
exec mysqld --user=mysql --bind-address=0.0.0.0 --port=3306
