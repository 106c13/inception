FROM debian:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y nginx openssh-server sudo && apt clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/sshd && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

RUN useradd -m -s /bin/bash docker && \
    echo "docker:123" | chpasswd && \
    adduser docker sudo

EXPOSE 22 80

CMD /usr/sbin/sshd && nginx -g "daemon off;"
