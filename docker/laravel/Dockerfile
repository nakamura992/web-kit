FROM php:8.3-fpm

COPY ./docker/laravel/php.ini /usr/local/etc/php/php.ini

ARG UID
ARG GID

RUN usermod -u ${UID} www-data && groupmod -g ${GID} www-data

RUN apt-get update && \
    apt-get -y install \
    git \
    zip \
    unzip \
    vim \
    nano \
    gosu \
    make \
    libonig-dev \
    && docker-php-ext-install pdo_mysql bcmath

# Composer install
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Node.js install
COPY --from=node:latest /usr/local/bin /usr/local/bin
COPY --from=node:latest /usr/local/lib /usr/local/lib

USER www-data