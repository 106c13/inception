FROM debian:bookworm

RUN apt update && \
    apt install -y python3 python3-pip && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install flask --no-cache-dir

WORKDIR /src
COPY src/ /src/

EXPOSE 5000

CMD ["python3", "main.py"]
