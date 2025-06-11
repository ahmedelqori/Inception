
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
	@echo "$(BLUE)Access your site at: https://ael-qori.42.fr$(NC)"

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

stats:
	@docker stats

images:
	@docker images | grep -E "(inception|nginx|wordpress|mariadb|alpine|debian)"

volumes:
	@docker volume ls | grep $(PROJECT_NAME)

networks:
	@docker network ls | grep $(PROJECT_NAME)

env:
	@echo "$(YELLOW)Environment variables:$(NC)"
	@cat srcs/.env 2>/dev/null || echo "$(RED).env file not found$(NC)"
