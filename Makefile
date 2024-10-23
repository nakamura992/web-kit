command-list:
	@echo "command-list:"
	@echo " make build             - docker compose build"
	@echo " make build-up          - docker compose up -d --build"
	@echo " make nbuild            - docker compose build --no-cache"
	@echo " make up                - docker compose up -d"
	@echo " make down              - docker compose down"
	@echo " make laravel           - docker compose exec laravel bash"
	@echo " make root-laravel      - docker compose exec -u root laravel /bin/bash"
	@echo " make nginx             - docker compose exec nginx sh"
	@echo " make to-next           - docker compose exec next sh"
	@echo " make vdown             - docker compose down -v"
	@echo " make vendor-to-host    - docker compose cp laravel:/var/www/html/vendor vendor-volume"
	@echo " make vendor-to-app     - docker compose cp ./vendor laravel:/var/www/html/vendor"
	@echo " make log               - docker compose logs"
	@echo " make log-laravel       - docker compose logs laravel"
	@echo " make log-next          - docker compose logs next"
	@echo " make log-nginx         - docker compose logs nginx"
	@echo " make log-mysql         - docker compose logs mysql"
	@echo " make log-mysql-backup  - docker compose logs mysql-backup"
	@echo " make log-pma           - docker compose logs pma"
	@echo " make log-certbot       - docker compose logs certbot"
	@echo " make stop              - docker compose stop"
	@echo " make stop-laravel      - docker compose stop laravel"
	@echo " make stop-next         - docker compose stop next"
	@echo " make stop-nginx        - docker compose stop nginx"
	@echo " make stop-mysql        - docker compose stop mysql"
	@echo " make stop-mysql-backup - docker compose stop mysql-backup"
	@echo " make stop-pma          - docker compose stop pma"
	@echo " make stop-certbot      - docker compose stop certbot"
	@echo " make ps                - docker compose ps"
	@echo " make create-next       - docker compose exec next bash -c \"npx create-next-app@latest\""
	@echo " make maintenance-on    - docker compose exec nginx touch /usr/share/nginx/html/maintenance/maintenance_mode"
	@echo " make maintenance-off   - docker compose exec nginx rm -f /usr/share/nginx/html/maintenance/maintenance_mode"
	@echo " make nginx-reload      - make nginx-test && docker compose exec nginx nginx -s reload"
	@echo " make nginx-test        - docker compose exec nginx nginx -t"
	@echo " make nginx-restart     - docker compose restart nginx"
    
# Docker commands
build:
	docker compose build

build-up:
	docker compose up -d --build

nbuild:
	docker compose build --no-cache

up:
	docker compose up -d

down:
	docker compose down

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

vendor-to-host:
	docker compose cp laravel:/var/www/html/vendor ./src/

vendor-to-container:
	docker compose cp ./src/vendor laravel:/var/www/html/

prod-up:
	docker compose -f docker-compose.prod.yml up -d

prod-up-build:
	docker compose -f docker-compose.prod.yml up -d --build

log-laravel:
	docker compose logs laravel

log-next:
	docker compose logs next

log-nginx:
	docker compose logs nginx

log-mysql:
	docker compose logs mysql

log-pma:
	docker compose logs pma

log-certbot:
	docker compose logs certbot

log-mysql-backup:
	docker compose logs mysql-backup

log:
	docker compose logs

stop:
	docker compose stop

stop-laravel:
	docker compose stop laravel

stop-next:
	docker compose stop next

stop-nginx:
	docker compose stop nginx

stop-mysql:
	docker compose stop mysql

stop-pma:
	docker compose stop pma

stop-certbot:
	docker compose stop certbot

stop-mysql-backup:
	docker compose stop mysql-backup

ps:
	docker compose ps

create-next:
	docker compose run --rm next npx create-next-app@latest

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

# Nginxを安全に再起動（ダウンタイムあり）
nginx-restart:
	@make nginx-test
	@docker compose restart nginx
