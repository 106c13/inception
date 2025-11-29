FROM debian:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y mariadb-server sudo && \
    apt clean && rm -rf /var/lib/apt/lists/*

COPY ./tools/script.sh /

RUN chmod +x /script.sh
RUN echo "bind-address = 0.0.0.0" >> /etc/mysql/mariadb.conf.d/50-server.cnf

CMD ["/script.sh"]
