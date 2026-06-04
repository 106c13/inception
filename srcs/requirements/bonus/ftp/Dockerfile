FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y vsftpd openssl && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/vsftpd/empty && \
    mkdir -p /var/log/vsftpd

COPY tools/script.sh /script.sh
RUN chmod +x /script.sh

EXPOSE 21 60000-60010

CMD ["/script.sh"]
