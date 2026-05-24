#!/bin/bash
set -e

echo "Waiting for database..."
for i in $(seq 1 15); do
    php artisan db:show --json > /dev/null 2>&1 && break
    echo "DB not ready, retrying in 2s... ($i/15)"
    sleep 2
done

php artisan config:clear
php artisan route:clear
php artisan view:clear

php artisan migrate --force

# Hanya seed jika belum ada data (cek tabel roles kosong)
ROLE_COUNT=$(php artisan tinker --execute="echo \App\Models\Role::count();" 2>/dev/null | tail -1)
if [ "$ROLE_COUNT" = "0" ] || [ -z "$ROLE_COUNT" ]; then
    echo "Seeding database..."
    php artisan db:seed --force
    echo "Seeding done!"
else
    echo "Database already seeded, skipping."
fi

apache2-foreground
