# User Documentation

## Overview

This project provides a complete web infrastructure composed of multiple Docker containers.

Available services:

| Service    | Purpose                    |
| ---------- | -------------------------- |
| Nginx      | HTTPS reverse proxy        |
| WordPress  | Main website               |
| MariaDB    | Database server            |
| Redis      | WordPress caching          |
| FTP Server | File transfer access       |
| Flask      | Additional web application |
| Adminer    | Database administration    |
| phpMyAdmin | Database administration    |

---

## Starting the Project

Start all services:

```bash
make
```

Verify containers are running:

```bash
docker ps
```

---

## Stopping the Project

Stop all services:

```bash
make down
```

Stop and remove containers:

```bash
make clean
```

Remove containers, images, and volumes:

```bash
make fclean
```

---

## Accessing the Services

### WordPress

```text
https://haaghaja.42.fr
```

### Adminer

```text
http://localhost:8080
```

### phpMyAdmin

```text
http://localhost:8081
```

### Flask Website

```text
http://localhost:5000
```

### FTP Server

```text
ftp://localhost:2121
```

---

## Credentials

Credentials are stored in:

```text
srcs/.env
```

and/or

```text
secrets/
```

Examples include:

* WordPress administrator account
* MariaDB credentials
* FTP credentials

Do not commit sensitive credentials to public repositories.

---

## Checking Service Status

Display running containers:

```bash
docker ps
```

Display logs:

```bash
make logs
```

Display logs for a specific container:

```bash
docker logs <container_name>
```

---

## Verifying the Installation

Check HTTPS:

```bash
curl -k https://haaghaja.42.fr
```

Check WordPress:

```text
https://haaghaja.42.fr
```

Check MariaDB container:

```bash
docker exec -it mariadb mysql -u root -p
```

Check Redis:

```bash
docker exec -it redis redis-cli ping
```

Expected output:

```text
PONG
```

