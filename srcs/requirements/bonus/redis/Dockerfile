FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y redis-server && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

RUN sed -i 's/bind 127.0.0.1/bind 0.0.0.0/' /etc/redis/redis.conf && \
    sed -i 's/protected-mode yes/protected-mode no/' /etc/redis/redis.conf && \
    sed -i 's/daemonize yes/daemonize no/' /etc/redis/redis.conf

RUN mkdir -p /data && \
    chown redis:redis /data

EXPOSE 6379

CMD ["redis-server", "--protected-mode", "no", "--bind", "0.0.0.0", "--daemonize", "no", "--dir", "/data"]
