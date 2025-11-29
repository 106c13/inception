#!/bin/bash
set -e

DATADIR="/var/lib/mysql"

mkdir -p "$DATADIR"
chown -R mysql:mysql "$DATADIR"

# FIX: required for socket
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# Detect first-time startup
if [ ! -f "$DATADIR/.initialized" ]; then
  echo "[mariadb] initializing database directory..."
  mariadb-install-db --user=mysql --datadir="$DATADIR" >/dev/null

  echo "[mariadb] starting temporary server for init..."
  mariadbd --skip-networking --socket=/run/mysqld/mysqld.sock \
           --user=mysql --datadir="$DATADIR" &
  TEMP_PID=$!

  # wait for server
  for i in {1..20}; do
    if mysqladmin --socket=/run/mysqld/mysqld.sock ping &>/dev/null; then
      break
    fi
    sleep 1
  done

  echo "[mariadb] running initial SQL setup..."
  mysql --socket=/run/mysqld/mysqld.sock <<EOF
CREATE DATABASE IF NOT EXISTS ${WORDPRESS_DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${WORDPRESS_DB_USER}'@'%' IDENTIFIED BY '${WORDPRESS_DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${WORDPRESS_DB_NAME}.* TO '${WORDPRESS_DB_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

  touch "$DATADIR/.initialized"

  echo "[mariadb] stopping temporary server..."
  mysqladmin --socket=/run/mysqld/mysqld.sock -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown || true
  wait $TEMP_PID 2>/dev/null || true
fi

echo "[mariadb] starting MariaDB..."
exec mariadbd --user=mysql --datadir="$DATADIR" --bind-address=0.0.0.0
