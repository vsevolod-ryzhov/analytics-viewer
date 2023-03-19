up: docker-up
init: docker-down-clear docker-pull docker-build docker-up init
test: test

docker-up:
	docker-compose up -d

docker-down:
	docker-compose down --remove-orphans

docker-down-clear:
	docker-compose down -v --remove-orphans

docker-pull:
	docker-compose pull

docker-build:
	docker-compose build

migrations:
	docker-compose run --rm php-cli php bin/console doctrine:migrations:migrate --no-interaction

logs:
	docker-compose logs --tail=100 -f $(c)

init: composer-install assets-install migrations fixtures

composer-install:
	docker-compose run --rm php-cli composer install
	docker-compose run --rm node npm rebuild node-sass

assets-install:
	docker-compose run --rm node yarn install

assets-dev:
	docker-compose run --rm node npm run dev

fixtures:
	docker-compose run --rm php-cli php bin/console doctrine:fixtures:load --no-interaction

test:
	docker-compose run --rm php-cli php bin/phpunit