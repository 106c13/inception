FROM debian:latest

RUN apt update && \
	apt install python3 python3-pip -y && \
	pip3 install flask

RUN mkdir /src/

COPY src* /src/

CMD ["python3", "/src/main.py"]
