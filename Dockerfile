FROM php:8.3-apache

RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev \
    libzip-dev libonig-dev zip unzip git curl nodejs npm \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        gd pdo_mysql mbstring zip bcmath opcache \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY composer.json composer.lock ./

RUN composer install \
    --optimize-autoloader --no-interaction \
    --no-dev --no-scripts --prefer-dist

COPY . .

RUN npm install && npm run build

RUN composer run-script post-autoload-dump || true

RUN mkdir -p storage/framework/sessions \
    storage/framework/views \
    storage/framework/cache \
    storage/logs bootstrap/cache \
    && chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

RUN sed -i 's|/var/www/html|/var/www/html/public|g' \
    /etc/apache2/sites-available/000-default.conf \
    && a2enmod rewrite headers

RUN echo '<Directory /var/www/html/public>\n\
    AllowOverride All\n\
    SetEnvIf X-Forwarded-Proto https HTTPS=on\n\
</Directory>' >> /etc/apache2/sites-available/000-default.conf

EXPOSE 80

CMD php artisan migrate --force --pretend 2>/dev/null; \
    php artisan migrate --force 2>/dev/null; \
    php artisan db:seed --force 2>/dev/null; \
    php artisan config:cache; \
    a2dismod mpm_event 2>/dev/null; true && \
    a2enmod mpm_prefork 2>/dev/null; true && \
    apache2-foreground
