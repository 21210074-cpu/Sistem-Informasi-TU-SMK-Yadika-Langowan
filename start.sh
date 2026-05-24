#!/bin/bash
set -e

a2dismod mpm_event mpm_worker 2>/dev/null || true
a2enmod mpm_prefork 2>/dev/null || true

echo "Waiting for database..."
for i in $(seq 1 15); do
    php artisan db:show --json > /dev/null 2>&1 && break
    echo "DB not ready, retrying in 2s... ($i/15)"
    sleep 2
done

php artisan config:clear
php artisan route:clear
php artisan view:clear
php artisan config:cache
php artisan route:cache

php artisan migrate --force

ROLE_COUNT=$(php artisan tinker --execute="echo \App\Models\Role::count();" 2>/dev/null | tail -1)
if [ "$ROLE_COUNT" = "0" ] || [ -z "$ROLE_COUNT" ]; then
    echo "Seeding database..."
    php artisan db:seed --force
    echo "Seeding done!"
else
    echo "Database already seeded, skipping."
fi

apache2-foreground
