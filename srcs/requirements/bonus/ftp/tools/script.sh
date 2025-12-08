#!/bin/bash
set -e

# Create SSL certs for vsftpd
mkdir -p /etc/ssl/private
openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout /etc/ssl/private/vsftpd.key \
  -out /etc/ssl/certs/vsftpd.pem \
  -subj "/C=FR/ST=Paris/L=Paris/O=42/OU=Inception/CN=ftp"

# Create FTP user if not exists
if ! id "$FTP_USER" &>/dev/null; then
    useradd -m "$FTP_USER"
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
fi

# Ensure FTP user has access to WordPress volume
mkdir -p /var/www/html/wordpress
chown -R "$FTP_USER":"$FTP_USER" /var/www/html/wordpress

# Configure vsftpd
cat >/etc/vsftpd.conf <<EOF
listen=YES
anonymous_enable=NO
local_enable=YES
write_enable=YES
chroot_local_user=YES
allow_writeable_chroot=YES

pasv_enable=YES
pasv_min_port=60000
pasv_max_port=60010
pasv_address=127.0.0.1

local_root=/var/www/html/wordpress
EOF

echo "[ftp] starting vsftpd..."
exec /usr/sbin/vsftpd /etc/vsftpd.conf
