#!/bin/bash
set -e

# Wait for database to be ready (up to 30 seconds)
echo "Waiting for database..."
for i in $(seq 1 15); do
    php artisan db:show --json > /dev/null 2>&1 && break
    echo "DB not ready, retrying in 2s... ($i/15)"
    sleep 2
done

php artisan route:clear
php artisan config:clear
php artisan migrate --force
php artisan db:seed --force
echo "Seeding done!"
apache2-foreground
