command-list:
	@echo "command-list:"
	@echo " make build                     - docker compose build"
	@echo " make build-up                  - docker compose up -d --build"
	@echo " make nbuild                    - docker compose build --no-cache"
	@echo " make up                        - docker compose up -d"
	@echo " make up-opt                    - docker compose up -d $$service"
	@echo " make down                      - docker compose down"
	@echo " make down-opt                  - docker compose down $$service"
	@echo " make laravel                   - docker compose exec laravel bash"
	@echo " make root-laravel              - docker compose exec -u root laravel /bin/bash"
	@echo " make nginx                     - docker compose exec nginx sh"
	@echo " make to-next                   - docker compose exec next sh"
	@echo " make vdown                     - docker compose down -v"
	@echo " make v-list                    - docker volume ls"
	@echo " make rm-v                      - docker volume rm"
	@echo " make vendor-to-host            - docker compose cp laravel:/var/www/html/vendor vendor-volume"
	@echo " make vendor-to-container       - docker compose cp ./vendor laravel:/var/www/html/vendor"
	@echo " make storage-to-host           - docker compose cp laravel:/var/www/html/storage storage-volume"
	@echo " make storage-to-container      - docker compose cp ./storage laravel:/var/www/html/storage"
	@echo " make node_m-to-host            - docker compose cp next:/app/node_modules node_modules-volume"
	@echo " make node_m-to-container       - docker compose cp ./next/node_modules next:/app/node_modules"
	@echo " make log                       - docker compose logs"
	@echo " make log-opt                   - docker compose logs $$service"
	@echo " make stop                      - docker compose stop"
	@echo " make stop-opt                  - docker compose stop $$service"
	@echo " make start                     - docker compose start"
	@echo " make start-opt                 - docker compose start $$service"
	@echo " make restart                   - docker compose restart"
	@echo " make restart-opt               - docker compose restart $$service"
	@echo " make ps                        - docker compose ps"
	@echo " make create-next               - docker compose run --rm -w / next npx create-next-app@latest /app"
	@echo " make maintenance-on            - make nginx-test && docker compose exec nginx touch $(MAINTENANCE_FILE)"
	@echo " make maintenance-off           - make nginx-test && docker compose exec nginx rm -f $(MAINTENANCE_FILE)"
	@echo " make nginx-reload              - make nginx-test && docker compose exec nginx nginx -s reload"
	@echo " make nginx-test                - docker compose exec nginx nginx -t"
# Docker commands
build:
	docker compose build

build-up:
	docker compose up -d --build

nbuild:
	docker compose build --no-cache

up:
	docker compose up -d

up-opt:
	@read -p "service name: " service; \
	docker compose up -d $$service

down:
	docker compose down

down-opt:
	@read -p "service name: " service; \
	docker compose down $$service

laravel:
	docker compose exec laravel bash

root-laravel:
	docker compose exec -u root laravel /bin/bash

nginx:
	docker compose exec nginx bash

to-next:
	docker compose exec next bash

vdown:
	docker compose down -v

v-list:
	docker volume ls

rm-v:
	@read -p "volume name: " volume; \
	docker volume rm $$volume

vendor-to-host:
	docker compose cp laravel:/var/www/html/vendor ./src/

vendor-to-container:
	docker compose cp ./src/vendor laravel:/var/www/html/

storage-to-host:
	docker compose cp laravel:/var/www/html/storage ./src/

storage-to-container:
	docker compose cp ./src/storage laravel:/var/www/html/

node_m-to-host:
	docker compose cp next:/app/node_modules ./next/

node_m-to-container:
	docker compose cp ./next/node_modules next:/app/

log:
	docker compose logs

log-opt:
	@read -p "service name: " service; \
	docker compose logs $$service

stop:
	docker compose stop

stop-opt:
	@read -p "service name: " service; \
	docker compose stop $$service

start:
	docker compose start

start-opt:
	@read -p "service name: " service; \
	docker compose start $$service

restart:
	docker compose restart

restart-opt:
	@read -p "service name: " service; \
	docker compose restart $$service

ps:
	docker compose ps

create-next:
	docker compose run --rm -w / next npx create-next-app /app

MAINTENANCE_FILE := /usr/share/nginx/html/maintenance/maintenance_mode
# メンテナンスモードを有効にする
maintenance-on:
	@docker compose exec nginx touch $(MAINTENANCE_FILE)
	@make nginx-reload

# メンテナンスモードを無効にする
maintenance-off:
	@docker compose exec nginx rm -f $(MAINTENANCE_FILE)
	@make nginx-reload

# nginxの設定ファイルのテストとリロード
nginx-reload:
	make nginx-test
	if [ $$? -eq 0 ]; then \
		docker compose exec nginx nginx -s reload; \
	fi

nginx-test:
	docker compose exec nginx nginx -t
