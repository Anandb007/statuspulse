.PHONY: build up down logs test clean shell restart ps

APP_CONTAINER=statuspulse-app

build:
	docker compose build

up:
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f

ps:
	docker compose ps

restart:
	docker compose restart

test:
	@echo "Testing StatusPulse health endpoint..."
	@curl -f http://localhost:8000/health || exit 1
	@echo "\nHealth check successful."

shell:
	docker exec -it $(APP_CONTAINER) /bin/bash

clean:
	docker compose down -v --rmi all
	docker system prune -f

test:
	docker compose down -v
	docker compose up -d --build -d
	sleep 10
	#COMPOSE_PROJECT_NAME=statuspulse_test docker compose up -d --build
	#sleep 10
	./tests/test_integration.sh
	#COMPOSE_PROJECT_NAME=statuspulse_test docker compose down -v
