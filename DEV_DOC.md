# Developer Documentation

## Prerequisites

* Docker
* Docker Compose
* GNU Make

Verify installation:

```bash
docker --version
docker compose version
make --version
```

---

## Setup

Clone the repository:

```bash
git clone <repository_url> inception
cd inception
```

Add the local domain:

```bash
echo "127.0.0.1 haaghaja.42.fr" | sudo tee -a /etc/hosts
```

Configure environment variables in:

```text
srcs/.env
```

---

## Build and Launch

Start the infrastructure:

```bash
make
```

The Makefile:

* Creates persistent data directories
* Builds Docker images
* Starts all containers

---

## Available Commands

| Command       | Description                            |
| ------------- | -------------------------------------- |
| `make`        | Build and start services               |
| `make down`   | Stop containers                        |
| `make clean`  | Stop containers and remove volumes     |
| `make fclean` | Full cleanup including images and data |
| `make logs`   | Display service logs                   |
| `make re`     | Rebuild everything                     |

---

## Services

### Mandatory

* Nginx (HTTPS reverse proxy, port 443)
* WordPress
* MariaDB

### Bonus

* Redis
* FTP Server (port 2121)
* Flask Website (port 5000)
* Adminer (port 8080)
* phpMyAdmin (port 8081)

---

## Data Persistence

Application data is stored on the host:

```text
/haaghaja/data/
├── db/
├── wp/
└── redis/
```

These directories are mounted into containers using Docker volumes, allowing data to persist after container recreation.

---

## Useful Docker Commands

List running containers:

```bash
docker ps
```

Open a shell inside a container:

```bash
docker exec -it <container_name> sh
```

Display logs:

```bash
docker logs <container_name>
```

---

## Project Structure

```text
.
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
├── srcs/
│   ├── docker-compose.yml
│   ├── .env
│   └── requirements/
│       ├── mariadb/
│       ├── nginx/
│       ├── wordpress/
│       └── bonus/
│           ├── redis/
│           ├── ftp/
│           ├── website/
│           ├── adminer/
│           └── phpmyadmin/
```

