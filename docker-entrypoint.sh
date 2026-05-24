#!/bin/bash

php artisan migrate --force 2>/dev/null || true
php artisan config:cache || true

exec apache2-foreground
