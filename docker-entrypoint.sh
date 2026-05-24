#!/bin/bash

# Fix Apache MPM conflict
a2dismod mpm_event mpm_worker 2>/dev/null || true
a2enmod mpm_prefork 2>/dev/null || true

# Run migrations (ignore if already exists)
php artisan migrate --force 2>/dev/null || true
php artisan config:cache || true

exec apache2-foreground
