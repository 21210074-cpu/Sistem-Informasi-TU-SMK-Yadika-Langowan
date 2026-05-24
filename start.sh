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

# Cek user count
USER_COUNT=$(php -r "
\$pdo = new PDO('mysql:host='.getenv('DB_HOST').';port='.getenv('DB_PORT').';dbname='.getenv('DB_DATABASE'), getenv('DB_USERNAME'), getenv('DB_PASSWORD'));
echo \$pdo->query('SELECT COUNT(*) FROM users')->fetchColumn();
")
echo "User count: $USER_COUNT"

if [ "$USER_COUNT" -le "1" ]; then
    echo "Seeding database..."
    php artisan db:seed --force
    echo "Seeding done!"
else
    echo "Database already seeded ($USER_COUNT users), skipping."
fi

# Cek employee count — jalankan DemoDataSeeder jika belum ada
EMPLOYEE_COUNT=$(php -r "
\$pdo = new PDO('mysql:host='.getenv('DB_HOST').';port='.getenv('DB_PORT').';dbname='.getenv('DB_DATABASE'), getenv('DB_USERNAME'), getenv('DB_PASSWORD'));
echo \$pdo->query('SELECT COUNT(*) FROM employees')->fetchColumn();
")
echo "Employee count: $EMPLOYEE_COUNT"

if [ "$EMPLOYEE_COUNT" = "0" ]; then
    echo "Seeding demo data..."
    php artisan db:seed --class=DemoDataSeeder --force
    echo "Demo seeding done!"
else
    echo "Demo data already exists ($EMPLOYEE_COUNT employees), skipping."
fi

apache2-foreground
