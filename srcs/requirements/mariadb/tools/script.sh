#!/bin/sh
set -e

# Create the required directory for the socket
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# Initialize database if not exists
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB database..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Start MariaDB temporarily
echo "Starting MariaDB temporarily..."
mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking --socket=/run/mysqld/mysqld.sock &
pid="$!"

# Wait for socket
while [ ! -S /run/mysqld/mysqld.sock ]; do
    sleep 1
done

# Secure installation and create WordPress database
echo "Configuring MariaDB..."
mysql -u root --socket=/run/mysqld/mysqld.sock <<EOF
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;

CREATE DATABASE IF NOT EXISTS $WORDPRESS_DB_NAME;
CREATE USER IF NOT EXISTS '$WORDPRESS_DB_USER'@'%' IDENTIFIED BY '$WORDPRESS_DB_PASSWORD';
GRANT ALL PRIVILEGES ON $WORDPRESS_DB_NAME.* TO '$WORDPRESS_DB_USER'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
FLUSH PRIVILEGES;
EOF

# Kill temporary instance
kill "$pid"
wait "$pid" 2>/dev/null || true

echo "MariaDB setup complete. Starting MariaDB..."

# Start MariaDB in foreground (PID 1)
exec mysqld --user=mysql --socket=/run/mysqld/mysqld.sock
