FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    php8.2-fpm \
    php8.2-mysql \
    php8.2-curl \
    php8.2-xml \
    php8.2-mbstring \
	php8.2-redis \
	redis-server \
    curl \
    less \
    unzip \
    mariadb-client \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY tools/script.sh /script.sh
RUN chmod +x /script.sh

CMD ["/script.sh"]
