NAME = inception

COMPOSE = docker compose -f srcs/docker-compose.yml

all:
	$(COMPOSE) up --build -d

clean:
	$(COMPOSE) down

fclean:
	$(COMPOSE) down -v
	docker system prune -af

re: fclean all

.PHONY: all start stop restart logs clean fclean re