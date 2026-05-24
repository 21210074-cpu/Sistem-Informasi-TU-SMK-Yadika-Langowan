#!/bin/bash
php artisan config:clear
php artisan migrate --force
php artisan db:seed --force
echo "Seeding done!"
exec apache2-foreground
