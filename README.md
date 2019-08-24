# Silverstripe 4 starter project with Docker
* Composer https://getcomposer.org/
* MailHog https://github.com/mailhog/MailHog
* Percona 5.7 https://www.percona.com/
* Nginx 1.17 https://nginx.org/
* PHP 7.3 https://www.php.net/ 

## Repos
* GitHub: https://github.com/derdiggn/silverstripe-docker
* Docker Hub: https://hub.docker.com/r/derdiggn/silverstripe-docker/tags

## Port Map
|Service|Internal|External|
|---|---|---|
|Mailhog SMTP|1025|
|Mailhog Webinterface|8025|8025|
|MySQL|3306|3306|
|Nginx|80|80|
|PHP|9000||

## Quickstart
```bash
$ cp .env.example .env
$ docker-compose build
$ bin/composer install
$ docker-compose up
```

Open http://localhost with your browser

## Usage
### Composer 
```bash
$ bin/composer 
```

### Docker Compose
```bash
# Build
$ docker-compose build

# Start
$ docker-compose up

# Stop
$ docker-compose down
```

### Docker Images
```bash
# Network
docker network create silverstripe

# PHP
docker run -d --rm \
    --name silverstripe_php \
    --net silverstripe \
    --net-alias php \
    -e PHP_DATE_TIMEZONE=Europe/Berlin \
    -e SS_DATABASE_SERVER=mysql.example.com \
    -e SS_DATABASE_USERNAME=silverstripe \
    -e SS_DATABASE_PASSWORD=silverstripe \
    -e SS_DATABASE_NAME=silverstripe \
    -v /path_to_your_silverstripe_project/:/srv/silverstripe/:rw,cached \
    derdiggn/silverstripe-docker:4-php-latest

# NGINX
docker run -d --rm \
    --name silverstripe_nginx \
    --net silverstripe \
    -p 80:80 \
    -v /path_to_your_silverstripe_project/assets:/srv/silverstripe/public/assets:ro \
    derdiggn/silverstripe-docker:4-nginx-latest
```

## Enviroment Variables
Example: https://github.com/derdiggn/silverstripe-docker/blob/master/.env.example

## Silverstripe Core
see https://docs.silverstripe.org/en/4/getting_started/environment_management/#core-environment-variables

## Custome
### PHP
```BASH
PHP_DATE_TIMEZONE=Europe/Berlin
PHP_POST_MAX_SIZE=6M
PHP_UPLOAD_MAX_FILESIZE=5M
````

### Silvrstripe
```BASH
SS_SMTP_HOST=mailhog
SS_SMTP_PORT=1025
SS_SMTP_ENCYPTION=
SS_SMTP_USERNAME=
SS_SMTP_PASSWORD=
SS_SMTP_AUTH_MODE=
```
