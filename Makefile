
DOCKER_COMPOSE = docker-compose
PROJECT_NAME = inception
CMD = $(DOCKER_COMPOSE) -f srcs/docker-compose.yml -p $(PROJECT_NAME)

DATA_DIR = /home/$(USER)/data

GREEN = \033[0;32m
YELLOW = \033[1;33m
RED = \033[0;31m
BLUE = \033[0;34m
NC = \033[0m 

all: setup build up

setup:
	@echo "$(YELLOW)Creating data directories...$(NC)"
	@mkdir -p $(DATA_DIR)/wordpress
	@mkdir -p $(DATA_DIR)/mariadb
	@echo "$(GREEN)Data directories created at $(DATA_DIR)$(NC)"

build:
	@echo "$(YELLOW)Building Docker images...$(NC)"
	@$(CMD) build --no-cache
	@echo "$(GREEN)Images built successfully!$(NC)"

up:
	@echo "$(YELLOW)Starting services...$(NC)"
	@$(CMD) up -d
	@echo "$(GREEN)Services are up and running!$(NC)"
	@echo "$(BLUE)Access your site at: https://$(USER).42.fr$(NC)"

down:
	@echo "$(YELLOW)Stopping services...$(NC)"
	@$(CMD) down
	@echo "$(GREEN)Services stopped!$(NC)"

clean:
	@echo "$(YELLOW)Stopping services and removing volumes...$(NC)"
	@$(CMD) down -v
	@echo "$(GREEN)Services stopped and volumes removed!$(NC)"

ps:
	@echo "$(YELLOW)Current running containers:$(NC)"
	@$(CMD) ps

fclean: down
	@echo "$(YELLOW)Performing full cleanup...$(NC)"
	@$(CMD) down --rmi all -v --remove-orphans
	@docker system prune -af
	@docker volume prune -f
	@echo "$(GREEN)Full cleanup completed!$(NC)"

clean-data:
	@echo "$(YELLOW)Removing data directories...$(NC)"
	@sudo rm -rf $(DATA_DIR)
	@echo "$(GREEN)Data directories removed!$(NC)"

reset: fclean clean-data setup

re: fclean all

start:
	@echo "$(YELLOW)Starting existing services...$(NC)"
	@$(CMD) start
	@echo "$(GREEN)Services started!$(NC)"

stop:
	@echo "$(YELLOW)Stopping services...$(NC)"
	@$(CMD) stop
	@echo "$(GREEN)Services stopped!$(NC)"

restart: stop start

logs:
	@$(CMD) logs -f

logs-nginx:
	@$(CMD) logs -f nginx

logs-wordpress:
	@$(CMD) logs -f wordpress

logs-mariadb:
	@$(CMD) logs -f mariadb

exec-nginx:
	@$(CMD) exec nginx /bin/sh

exec-wordpress:
	@$(CMD) exec wordpress /bin/sh

exec-mariadb:
	@$(CMD) exec mariadb /bin/sh

stats:
	@docker stats

images:
	@docker images | grep -E "(inception|nginx|wordpress|mariadb|alpine|debian)"

volumes:
	@docker volume ls | grep $(PROJECT_NAME)

networks:
	@docker network ls | grep $(PROJECT_NAME)

validate:
	@echo "$(YELLOW)Validating docker-compose file...$(NC)"
	@$(CMD) config
	@echo "$(GREEN)Docker-compose file is valid!$(NC)"

status:
	@echo "$(YELLOW)=== Inception Project Status ===$(NC)"
	@echo "$(GREEN)Containers:$(NC)"
	@$(CMD) ps
	@echo ""
	@echo "$(GREEN)Images:$(NC)"
	@docker images | grep -E "(inception|nginx|wordpress|mariadb)" || echo "No inception images found"
	@echo ""
	@echo "$(GREEN)Volumes:$(NC)"
	@docker volume ls | grep $(PROJECT_NAME) || echo "No inception volumes found"
	@echo ""
	@echo "$(GREEN)Networks:$(NC)"
	@docker network ls | grep $(PROJECT_NAME) || echo "No inception networks found"
	@echo ""
	@echo "$(GREEN)Data directories:$(NC)"
	@ls -la $(DATA_DIR) 2>/dev/null || echo "Data directories not found at $(DATA_DIR)"

health:
	@echo "$(YELLOW)Checking service health...$(NC)"
	@curl -k https://localhost:443 >/dev/null 2>&1 && echo "$(GREEN)✓ NGINX is responding$(NC)" || echo "$(RED)✗ NGINX is not responding$(NC)"
	@$(CMD) exec wordpress wp --info --allow-root >/dev/null 2>&1 && echo "$(GREEN)✓ WordPress is accessible$(NC)" || echo "$(RED)✗ WordPress is not accessible$(NC)"
	@$(CMD) exec mariadb mysql -u root -p$(MYSQL_ROOT_PASSWORD) -e "SELECT 1;" >/dev/null 2>&1 && echo "$(GREEN)✓ MariaDB is accessible$(NC)" || echo "$(RED)✗ MariaDB is not accessible$(NC)"

backup:
	@echo "$(YELLOW)Creating backup...$(NC)"
	@tar -czf inception_backup_$(shell date +%Y%m%d_%H%M%S).tar.gz $(DATA_DIR)
	@echo "$(GREEN)Backup created successfully!$(NC)"

env:
	@echo "$(YELLOW)Environment variables:$(NC)"
	@cat srcs/.env 2>/dev/null || echo "$(RED).env file not found$(NC)"

update:
	@echo "$(YELLOW)Pulling latest base images...$(NC)"
	@docker pull alpine:3.22.0
	@docker pull debian:bullseye
	@echo "$(GREEN)Base images updated!$(NC)"

disk:
	@echo "$(YELLOW)Docker disk usage:$(NC)"
	@docker system df

.PHONY: all build up down clean ps fclean start stop restart logs logs-nginx logs-wordpress logs-mariadb exec-nginx exec-wordpress exec-mariadb stats images volumes networks validate status health backup env update disk setup clean-data reset re help