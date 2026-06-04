#!/bin/sh
set -e

# Create required directories for vsftpd
mkdir -p /var/run/vsftpd/empty
mkdir -p /var/log/vsftpd

# Create SSL certs for vsftpd
mkdir -p /etc/ssl/private
openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout /etc/ssl/private/vsftpd.key \
  -out /etc/ssl/certs/vsftpd.pem \
  -subj "/C=FR/ST=Paris/L=Paris/O=42/OU=Inception/CN=haaghaja.42.fr"

# Create FTP user if not exists
if ! id "$FTP_USER" &>/dev/null; then
    useradd -m -s /bin/bash "$FTP_USER"
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
fi

# Ensure FTP user has access to WordPress volume
chown -R "$FTP_USER":"$FTP_USER" /var/www/html

# Configure vsftpd
cat >/etc/vsftpd.conf <<EOF
listen=YES
listen_ipv6=NO
anonymous_enable=NO
local_enable=YES
write_enable=YES
chroot_local_user=YES
allow_writeable_chroot=YES
seccomp_sandbox=NO

# Required directories
secure_chroot_dir=/var/run/vsftpd/empty
xferlog_file=/var/log/vsftpd/vsftpd.log

# SSL configuration
ssl_enable=YES
rsa_cert_file=/etc/ssl/certs/vsftpd.pem
rsa_private_key_file=/etc/ssl/private/vsftpd.key
ssl_tlsv1=YES
ssl_sslv2=NO
ssl_sslv3=NO
require_ssl_reuse=NO
force_local_logins_ssl=NO
force_local_data_ssl=NO

# Passive mode
pasv_enable=YES
pasv_min_port=60000
pasv_max_port=60010
pasv_address=127.0.0.1

# User settings
local_root=/var/www/html
EOF

# Fix permissions
chmod 755 /var/run/vsftpd/empty

echo "[ftp] starting vsftpd..."
exec /usr/sbin/vsftpd /etc/vsftpd.conf
