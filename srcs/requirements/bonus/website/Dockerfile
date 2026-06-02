FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y python3 python3-pip python3-venv && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install flask --no-cache-dir --break-system-packages

WORKDIR /src
COPY src/ /src/

EXPOSE 5000

CMD ["python3", "main.py"]
