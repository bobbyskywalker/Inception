DOCKER_COMPOSE = ./srcs/docker-compose.yaml
DOCKER_LOGIN = olek

# WordPress
WP_DOMAIN = $(DOCKER_LOGIN).42.fr
WP_TITLE = page42
WP_ADMIN = admin42
WP_ADMIN_PSWD = pass
WP_ADMIN_EMAIL = email@address.com
WP_USER = user
WP_PSWD = pass
WP_EMAIL = email@address.com

# MariaDB
MARIADB_DBNAME = db
MARIADB_ADMIN_USER = admin42
MARIADB_ROOT_PSWD = pass

all: up

create:
	@mkdir -p /home/$(DOCKER_LOGIN)/data/wp
	@chmod 777 /home/$(DOCKER_LOGIN)/data/wp
	@mkdir -p /home/$(DOCKER_LOGIN)/data/mdb
	@chmod 777 /home/$(DOCKER_LOGIN)/data/mdb
	@if ! grep -q "127.0.0.1 $(WP_DOMAIN)" /etc/hosts; then \
		echo "Adding $(WP_DOMAIN) to /etc/hosts..."; \
		echo "127.0.0.1 $(WP_DOMAIN)" | sudo tee -a /etc/hosts > /dev/null; \
	fi

up: create
	@docker compose -f $(DOCKER_COMPOSE) up -d --no-deps --build --remove-orphans --wait
	@echo "Waiting for WordPress to fully install..."
	@until docker exec wordpress wp core is-installed --allow-root > /dev/null 2>&1; do \
		echo "⏳ Waiting for WordPress setup to finish..."; \
		sleep 2; \
	done
	@$(MAKE) set-site


down:
	@docker compose -f $(DOCKER_COMPOSE) down

clean:
	@echo "Removing $(WP_DOMAIN) from /etc/hosts if it exists..."
	@sudo sed -i "/127.0.0.1 $(WP_DOMAIN)/d" /etc/hosts
	@docker system prune --all -f
	@docker rm -q $$(docker ps -qa) 2> /dev/null || true
	@docker rmi -f $$(docker images -qa) 2> /dev/null || true
	@docker volume rm $$(docker volume ls -q) 2> /dev/null || true
	@rm -rf /home/$(DOCKER_LOGIN)/data

fclean: down clean

re: fclean all

status:
	@docker ps

logs:
	@echo "\n[ LOGS: mariadb ]\n"
	@docker logs mariadb
	@echo "\n[ LOGS: wordpress ]\n"
	@docker logs wordpress
	@echo "\n[ LOGS: nginx ]\n"
	@docker logs nginx

set-site:
	@docker exec -it wordpress wp option update blogname "$(WP_TITLE)" --allow-root
	@docker exec -it wordpress wp option update siteurl "https://$(WP_DOMAIN)" --allow-root
	@docker exec -it wordpress wp option update home "https://$(WP_DOMAIN)" --allow-root


.PHONY: all create up down clean fclean re status logs set-site
