# Silverstripe 4 starter project with Docker
* Composer https://getcomposer.org/
* MailHog https://github.com/mailhog/MailHog
* Percona 5.7 https://www.percona.com/
* Nginx 1.17 https://nginx.org/
* PHP 7.3 https://www.php.net/ 

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

### Build
```bash
$ docker-compose build
```

### Run
```bash
$ docker-compose up
```

### Stop
```bash
$ docker-compose down
```
