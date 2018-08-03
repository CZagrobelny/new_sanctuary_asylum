VERSION=1
BUILD_DATE=$(shell date +%Y%m%dT%H%M)

export VERSION
export BUILD_DATE

all: build up

ensure_perms:
	@echo "Ensuring that shell scripts are executable on the host, since host perms will override container perms"
	chmod +x ./wait-for-it.sh

build: ensure_perms
	@echo "Building the containers..."
	VERSION=$(VERSION) BUILD_DATE=$(BUILD_DATE) docker-compose -f docker-compose.yml build

up:
	@echo "Composing the containers..."
	docker-compose -f docker-compose.yml up

force_up:
	@echo "Forcibly re-building and standing-up containers"
	docker-compose -f docker-compose.yml down --rmi all && docker-compose -f docker-compose.yml up --build --force-recreate

down:
	@echo "Removing compose constructs"
	docker-compose -f docker-compose.yml down

down_clean:
	@echo "Removing compose constructs and images"
	docker-compose -f docker-compose.yml down --rmi all

.PHONY: all
