FROM debian:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y mariadb-server openssh-server sudo && \
    apt clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/sshd && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

RUN useradd -m -s /bin/bash docker && \
    echo "docker:123" | chpasswd && \
    adduser docker sudo

RUN mysqld --user=mysql --bootstrap <<EOF
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY 'root';
CREATE USER 'root'@'%' IDENTIFIED BY 'root';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

RUN sed -i 's/^bind-address\s*=.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

EXPOSE 22 3306

CMD service mariadb start && /usr/sbin/sshd -D

