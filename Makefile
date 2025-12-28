NAME        := inception
COMPOSE     := docker compose -f srcs/docker-compose.yml
DATA_DIR    := /home/necro/data
DB_DIR      := $(DATA_DIR)/db
WP_DIR      := $(DATA_DIR)/wp

all: up

dirs:
	@mkdir -p $(DB_DIR)
	@mkdir -p $(WP_DIR)
	@echo "✔ Data directories created"

build: dirs
	$(COMPOSE) build

up: build
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down -v

fclean: clean
	$(COMPOSE) down --rmi all --remove-orphans
	@docker image prune -f
	@echo "✔ Full cleanup complete"

logs:
	$(COMPOSE) logs -f

re: fclean all

.PHONY: all dirs build up down clean fclean logs re
