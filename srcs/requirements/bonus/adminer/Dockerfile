FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y php8.2 php8.2-mysql php8.2-pgsql php8.2-mysqli && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

COPY tools/adminer.php /var/www/html/index.php

COPY tools/adminer.conf /etc/php/8.2/fpm/conf.d/99-adminer.ini

RUN chown -R www-data:www-data /var/www/html && \
    chmod 644 /var/www/html/index.php

EXPOSE 8080

CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]
