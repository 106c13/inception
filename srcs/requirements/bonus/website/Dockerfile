FROM debian:bookworm

RUN apt update && \
    apt install -y python3 python3-pip

RUN pip3 install --break-system-packages flask

WORKDIR /src
COPY src/ /src/

CMD ["python3", "main.py"]
