FROM php:latest

RUN apt-get update && apt-get install -y \
    docker-php-ext-install zip

WORKDIR /app

COPY . .