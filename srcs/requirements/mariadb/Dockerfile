FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y mariadb-server mariadb-client && \
    apt clean && rm -rf /var/lib/apt/lists/*

COPY tools/script.sh /script.sh
RUN chmod +x /script.sh

RUN sed -i 's/bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/' \
    /etc/mysql/mariadb.conf.d/50-server.cnf

EXPOSE 3306

CMD ["/script.sh"]
