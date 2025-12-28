FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

RUN apt -y update && apt install -y nginx && apt install openssl -y

COPY tools/script.sh /
COPY tools/nginx.conf /etc/nginx/conf.d/default.conf

RUN chmod +x /script.sh

CMD ["/script.sh"]
