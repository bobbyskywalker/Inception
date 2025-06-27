#!/bin/bash

set -x

mkdir -p /var/www/html
mkdir -p /run/php
cd /var/www/html

# downloading the wordpress onto this machine
wp-cli.phar core download --allow-root

# creating configuration files at the default location of wordpress
wp-cli.phar config create \
	--dbname=$MARIADB_DBNAME \
	--dbuser=$MARIADB_ADMIN_USER \
	--dbpass=$MARIADB_ROOT_PSWD \
	--dbhost=mariadb:3306 \
	--allow-root \
	--skip-check

# installing the wordpress page
wp-cli.phar core install \
	--url=$WP_DOMAIN \
	--title=$WP_TITLE \
	--admin_user=$WP_ADMIN_USR \
	--admin_password=$WP_ADMIN_PSWD \
	--admin_email=$WP_ADMIN_EMAIL \
	--skip-email \
	--allow-root

# administrator role
wp-cli.phar user create $WP_ADMIN $WP_ADMIN_EMAIL \
	--role=administrator \
	--user_pass=$WP_ADMIN_PSWD \
	--allow-root

# regular user
wp-cli.phar user create $WP_USER $WP_EMAIL \
	--user_pass=$WP_PSWD \
	--allow-root

# configuring the config
wp-cli.phar config set FORCE_SSS_ADMIN 'false' --allow-root

# setting up a theme
wp-cli.phar theme install astra --activate --allow-root
wp-cli.phar plugin update --all --allow-root

chmod 777 /var/www/html/wp-content

# launching the php runtime
/usr/sbin/php-fpm7.4 -F
