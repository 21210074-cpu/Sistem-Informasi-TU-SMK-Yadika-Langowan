#!/bin/bash
set -e
php artisan route:clear
php artisan config:clear
php artisan migrate --force
php artisan db:seed --force
echo "Seeding done!"
apache2-foreground
