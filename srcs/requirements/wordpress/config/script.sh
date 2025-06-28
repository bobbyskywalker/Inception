#!/bin/bash
set -e

echo "📦 Starting WordPress setup..."

# Ensure working directory exists
mkdir -p /var/www/html
cd /var/www/html

# Download WordPress
wp core download --allow-root

# Create wp-config.php
wp config create \
    --dbname=$MARIADB_DBNAME \
    --dbuser=$MARIADB_ADMIN_USER \
    --dbpass=$MARIADB_ROOT_PSWD \
    --dbhost=mariadb:3306 \
    --allow-root \
    --skip-check

# Install WordPress core
wp core install \
    --url=https://$WP_DOMAIN \
    --title="$WP_TITLE" \
    --admin_user=$WP_ADMIN \
    --admin_password=$WP_ADMIN_PSWD \
    --admin_email=$WP_ADMIN_EMAIL \
    --skip-email \
    --allow-root

# Create regular user
wp user create $WP_USER $WP_EMAIL \
    --user_pass=$WP_PSWD \
    --role=author \
    --allow-root

# Theme & plugin setup
wp theme install astra --activate --allow-root
wp plugin update --all --allow-root

# Set permissions
chmod -R 755 /var/www/html

# Start PHP-FPM
exec php-fpm7.4 -F
