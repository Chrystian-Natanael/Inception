USER = chrystian-natanael

MARIA_DB_DIR = /home/$(USER)/data/mariadb
WP_PHP_DIR = /home/$(USER)/data/wordpress

COMPOSER_FILE = ./srcs/docker-compose.yml
DOCKER_COMPOSE_EXE = docker compose -f $(COMPOSER_FILE)


all: config up

config:
	@if [ ! -f ./srcs/.env ]; then \
		wget -O ./srcs/.env https://raw.githubusercontent.com/Chrystian-Natanael/Inception/refs/heads/master/srcs/.env; \
	fi

	@if ! grep -q '$(USER)' /etc/hosts; then \
		echo "127.0.0.1 $(USER).42.fr" | sudo tee -a /etc/hosts > /dev/null; \
	fi

	@if [ ! -d "$(WP_PHP_DIR)" ]; then \
		sudo mkdir -p $(WP_PHP_DIR); \
	fi
	@if [ ! -d "$(MARIA_DB_DIR)" ]; then \
		sudo mkdir -p $(MARIA_DB_DIR); \
	fi

build:
	$(DOCKER_COMPOSE_EXE) build

up: build
	$(DOCKER_COMPOSE_EXE) up -d

down:
	$(DOCKER_COMPOSE_EXE) down



ps:
	$(DOCKER_COMPOSE_EXE) ps

ls:
	docker volume ls

clean:
	$(DOCKER_COMPOSE_EXE) down --rmi all --volumes

fclean: clean
	# rm ./srcs/.env
	docker system prune --force --all --volumes
	sudo rm -rf /home/$(USER)/data

re: fclean all

.PHONY: all up config build down ls clean fclean hard

hard: update all

update:
	sudo apt-get update && sudo apt-get upgrade -yq
