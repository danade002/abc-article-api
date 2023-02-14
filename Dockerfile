FROM composer as builder
WORKDIR /app
COPY composer.* ./
RUN composer update --no-scripts

FROM php:8.1-fpm-alpine
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
WORKDIR /app
COPY --from=builder /app/vendor /app/vendor
COPY . /app
COPY .env.example .env
RUN composer install --no-scripts
CMD ash -c "composer install && php artisan serve --host 0.0.0.0 --port 5001"
