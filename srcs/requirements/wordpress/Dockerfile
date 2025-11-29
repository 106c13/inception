FROM debian:latest

RUN apt update -y && \
	apt install php8.4-fpm php-mysql -y && \ 
	apt install curl -y

COPY ./tools/script.sh /

RUN chmod +x /script.sh

CMD [ "/script.sh" ]
