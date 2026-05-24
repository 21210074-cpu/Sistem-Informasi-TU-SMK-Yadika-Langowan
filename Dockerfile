FROM php:8.3-apache

RUN sed -i 's|/var/www/html|/var/www/html/public|g' \
    /etc/apache2/sites-available/000-default.conf \
    && sed -i 's/Listen 80/Listen 8000/' /etc/apache2/ports.conf \
    && sed -i 's/:80>/:8000>/' /etc/apache2/sites-available/000-default.conf \
    && a2dismod mpm_event mpm_worker || true \
    && a2enmod mpm_prefork rewrite headers

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY composer.json composer.lock ./

RUN composer install \
    --optimize-autoloader --no-interaction \
    --no-dev --no-scripts --prefer-dist

COPY . .

RUN composer run-script post-autoload-dump || true

RUN mkdir -p storage/framework/sessions \
    storage/framework/views \
    storage/framework/cache \
    storage/logs bootstrap/cache \
    && chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

RUN sed -i 's|/var/www/html|/var/www/html/public|g' \
    /etc/apache2/sites-available/000-default.conf \
    && sed -i 's/Listen 80/Listen 8000/' /etc/apache2/ports.conf \
    && sed -i 's/:80>/:8000>/' /etc/apache2/sites-available/000-default.conf \
    && a2enmod rewrite \
    && a2dismod mpm_event || true \
    && a2enmod mpm_prefork

RUN echo '<Directory /var/www/html/public>\n\
    AllowOverride All\n\
    SetEnvIf X-Forwarded-Proto https HTTPS=on\n\
</Directory>' >> /etc/apache2/sites-available/000-default.conf \
    && a2enmod headers

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 8000

ENTRYPOINT ["docker-entrypoint.sh"]
