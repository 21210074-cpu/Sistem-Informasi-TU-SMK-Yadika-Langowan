#!/bin/bash
set -e

php artisan migrate --force 2>/dev/null || true
php artisan config:cache

apache2-foreground
