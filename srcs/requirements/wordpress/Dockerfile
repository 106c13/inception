FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    php8.2-fpm \
    php8.2-mysql \
    curl \
    less \
    unzip \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

RUN ln -sf /usr/sbin/php-fpm8.2 /usr/sbin/php-fpm

COPY ./tools/script.sh /

RUN chmod +x /script.sh

CMD ["/script.sh"]
