COMPOSE = docker compose -f srcs/docker-compose.yml

build:
	$(COMPOSE) build --no-cache

up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

logs:
	$(COMPOSE) logs -f

clean:
	$(COMPOSE) down -v --rmi all --remove-orphans

.PHONY: build up down logs clean
