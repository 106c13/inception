NAME        := inception
COMPOSE     := docker compose -f srcs/docker-compose.yml
DATA_DIR    := /tmp/haaghaja/data
DB_DIR      := $(DATA_DIR)/db
WP_DIR      := $(DATA_DIR)/wp
PORTAINER_DIR := $(DATA_DIR)/portainer

all: up

dirs:
	@mkdir -p $(DB_DIR)
	@mkdir -p $(WP_DIR)
	@mkdir -p $(PORTAINER_DIR)
	@echo "✔ Data directories created at $(DATA_DIR)"

build: dirs
	$(COMPOSE) build

up: build
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down -v

fclean: clean
	$(COMPOSE) down --rmi all --remove-orphans 2>/dev/null || true
	@docker system prune -f 2>/dev/null || true
	@sudo rm -rf $(DATA_DIR)
	@echo "✔ Full cleanup complete (removed $(DATA_DIR))"

logs:
	$(COMPOSE) logs -f

re: fclean all

.PHONY: all dirs build up down clean fclean logs re
