ARG PHP_VERSION=7.3
ARG NGINX_VERSION=1.17

## PHP
FROM php:${PHP_VERSION}-fpm-alpine AS silverstripe_php

# Install PHP extensions and build dependencies
RUN set -xe \
    && apk add --no-cache --update \
        bash \
        freetype \
        icu \
        libjpeg \
        libpng \
        libxpm \
        libzip \
        tidyhtml \
    && apk add --no-cache --virtual .php-deps \
        make \
    && apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        freetype-dev \
        icu-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        libxpm-dev \
        libzip-dev \
        tidyhtml-dev \
        g++ \
    && docker-php-ext-configure gd --with-png-dir=/usr/include --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/  \
    && docker-php-ext-configure intl \
    && docker-php-ext-configure mysqli --with-mysqli=mysqlnd \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    && docker-php-ext-install -j$(nproc) \
 		intl \
 		gd \
 		mysqli \
 		pdo \
 		pdo_mysql \
 		tidy \
    && docker-php-ext-enable \
 		intl \
 		gd \
 		mysqli \
 		pdo \
 		pdo_mysql \
 		tidy \
    && apk del .build-deps \
    && rm -rf /tmp/* /usr/local/lib/php/doc/* /var/cache/apk/*

# php.ini and entrypoint
COPY docker/php/docker-php-entrypoint /usr/local/bin/
COPY docker/php/php.ini ${PHP_INI_DIR}/php.ini

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN set -eux; \
	composer global require "hirak/prestissimo:^0.3" --prefer-dist --no-progress --no-suggest --classmap-authoritative; \
	composer clear-cache
ENV PATH="${PATH}:/root/.composer/vendor/bin"

WORKDIR /srv/silverstripe

# build for production
ARG SS_ENVIRONMENT_TYPE=live

# prevent the reinstallation of vendors at every changes in the source code
COPY composer.json composer.lock ./
RUN set -eux; \
	composer install --prefer-dist --optimize-autoloader --no-scripts --no-progress --no-suggest; \
	composer clear-cache

# copy application files
COPY ./public ./public
COPY ./app ./app
COPY ./themes ./themes

# vendor expose
RUN /usr/bin/composer vendor-expose copy


## NGINX
FROM nginx:${NGINX_VERSION}-alpine AS silverstripe_nginx

COPY docker/nginx/conf.d/default.conf /etc/nginx/conf.d/

WORKDIR /srv/silverstripe

COPY --from=silverstripe_php /srv/silverstripe/public public/
