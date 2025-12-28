FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y vsftpd openssl && \
    apt clean && rm -rf /var/lib/apt/lists/*

COPY tools/script.sh /script.sh
RUN chmod +x /script.sh

CMD ["/script.sh"]
