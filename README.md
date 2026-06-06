*This project has been created as part of the 42 curriculum by haaghaja.*

# Inception

## Description

Inception is a system administration project from the 42 curriculum focused on containerization using Docker.

The objective of the project is to build a complete web infrastructure composed of multiple isolated services running in separate Docker containers. Each service is configured through custom Dockerfiles and connected through a dedicated Docker network.

The infrastructure includes:

* Nginx with TLSv1.2/TLSv1.3 support
* WordPress with PHP-FPM
* MariaDB database
* Redis cache
* FTP server
* Flask website
* Adminer
* phpMyAdmin

Persistent data is stored using Docker volumes to ensure data remains available even when containers are recreated.

## Project Structure

```text
.
├── Makefile
├── secrets/
├── srcs/
│   ├── docker-compose.yml
│   ├── .env
│   └── requirements/
│       ├── nginx/
│       ├── mariadb/
│       ├── wordpress/
│       ├── redis/
│       ├── ftp/
│       ├── flask/
│       ├── adminer/
│       └── phpmyadmin/
└── README.md
```

## Instructions

### Prerequisites

* Docker
* Docker Compose
* GNU Make

### Setup

Clone the repository:

```bash
git clone <repository_url> inception
cd inception
```

Configure the host:

```bash
echo "127.0.0.1 haaghaja.42.fr" | sudo tee -a /etc/hosts
```

Create the environment file:

```bash
cp srcs/.env.example srcs/.env
```

Fill the required variables in `.env`.

### Build and Run

```bash
make
```

### Available Commands

```bash
make        # Build and start containers
make down   # Stop containers
make clean  # Remove containers
make fclean # Full cleanup (containers, images, volumes)
make re     # Rebuild everything
make logs   # Display logs
```

## Services

| Service    | Purpose                           |
| ---------- | --------------------------------- |
| Nginx      | Reverse proxy and TLS termination |
| WordPress  | CMS application                   |
| MariaDB    | Database backend                  |
| Redis      | WordPress cache                   |
| FTP        | File transfer access              |
| Flask      | Additional web application        |
| Adminer    | Database administration           |
| phpMyAdmin | Database administration           |

## Design Choices

### Docker vs Virtual Machines

#### Virtual Machines

* Include a complete guest operating system
* Require more RAM and storage
* Longer startup times
* Stronger isolation

#### Docker

* Share the host kernel
* Lightweight
* Fast startup
* Easier deployment and portability

Docker was chosen because it provides efficient isolation with significantly lower resource consumption.

### Secrets vs Environment Variables

#### Environment Variables

* Easy to configure
* Visible through container inspection
* Suitable for non-sensitive configuration

#### Docker Secrets

* Designed for sensitive information
* Not exposed as environment variables
* Better security for passwords and credentials

Secrets are used whenever sensitive credentials must be protected.

### Docker Network vs Host Network

#### Host Network

* Container shares host networking stack
* No isolation
* Higher risk of port conflicts

#### Docker Network

* Isolated communication
* Service discovery through container names
* Better security and organization

A dedicated Docker network is used to isolate services and simplify communication.

### Docker Volumes vs Bind Mounts

#### Bind Mounts

* Direct mapping to host directories
* Useful during development
* Host-dependent paths

#### Docker Volumes

* Managed by Docker
* Better portability
* Easier backups and maintenance

Volumes are used to persist database and WordPress data independently from containers.

## Data Persistence

Persistent data is stored outside containers:

```text
/home/haaghaja/data/
├── mariadb/
├── wordpress/
└── redis/
```

This prevents data loss when containers are recreated.

## Security

The infrastructure follows several security practices:

* HTTPS enforced through Nginx
* TLSv1.2 and TLSv1.3 support
* Service isolation using containers
* Dedicated Docker network
* Sensitive credentials stored separately
* No direct exposure of internal services

## Resources

### Documentation

* https://docs.docker.com/
* https://docs.docker.com/compose/
* https://nginx.org/en/docs/
* https://mariadb.com/kb/en/documentation/
* https://wordpress.org/documentation/
* https://redis.io/docs/

### AI Usage

ChatGPT was used as an educational and debugging assistant during the development of this project.

Areas where AI assistance was used:

* Docker networking troubleshooting
* Docker Compose configuration debugging
* Nginx configuration explanations
* Redis integration with WordPress
* General Docker concepts
* Documentation and README structure

All implementation, testing, configuration, and validation were performed manually.

```
```

