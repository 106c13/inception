FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y wget tar && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget -q https://github.com/portainer/portainer/releases/download/2.21.4/portainer-2.21.4-linux-amd64.tar.gz && \
    tar -xzf portainer-2.21.4-linux-amd64.tar.gz && \
    rm portainer-2.21.4-linux-amd64.tar.gz && \
    mv portainer /usr/local/bin/portainer && \
    chmod +x /usr/local/bin/portainer

RUN mkdir -p /data

EXPOSE 9000

CMD ["/usr/local/bin/portainer", "--bind", ":9000", "--data", "/data"]
