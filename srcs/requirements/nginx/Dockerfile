FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    nginx \
    openssl \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/haaghaja.42.fr.key \
    -out /etc/nginx/ssl/haaghaja.42.fr.crt \
    -subj "/C=FR/ST=Paris/L=Paris/O=42/CN=haaghaja.42.fr"

COPY tools/nginx.conf /etc/nginx/conf.d/default.conf
COPY tools/script.sh /script.sh

RUN chmod +x /script.sh

# IMPORTANT: Run nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
