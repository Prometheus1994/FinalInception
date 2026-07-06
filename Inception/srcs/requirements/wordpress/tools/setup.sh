#!/bin/bash

set -e
# if any command failed stop script

mkdir -p /var/www/html
# the directory where wordpress will be stored

mkdir -p /run/php

wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
# wp-cli.phar file is the tool with whom we will manage wordpress

if [ ! -f /var/www/html/wp-load.php ]
then
	wp core download --path=/var/www/html --allow-root
fi

MYSQL_PASSWORD=$(cat /run/secrets/db_password)

until mariadb \
	-hmariadb \
	-u"$MYSQL_USER" \
	-p"$MYSQL_PASSWORD" \
	-e "SELECT 1;" >/dev/null 2>&1
do
	echo "Waiting for MariaDB..."
	sleep 1
done
# don't download wordpress until mariadb is ready

if [ ! -f /var/www/html/wp-config.php ]
then
	wp config create --path=/var/www/html --allow-root \
		--dbname="$MYSQL_DATABASE" \
		--dbuser="$MYSQL_USER" \
		--dbpass="$MYSQL_PASSWORD" \
		--dbhost="mariadb:3306"
fi
# wp-config.php file will contain database settings

WP_ADMIN_PASSWORD=$(sed -n '1p' /run/secrets/credentials)
WP_USER_PASSWORD=$(sed -n '2p' /run/secrets/credentials)

if ! wp core is-installed --path=/var/www/html --allow-root >/dev/null 2>&1
then
	wp core install --path=/var/www/html --allow-root \
		--url="$DOMAIN_NAME" \
		--title="Inception" \
		--admin_user="$WP_ADMIN_USER" \
		--admin_password="$WP_ADMIN_PASSWORD" \
		--admin_email="admin@example.com"
fi
# install wordpress and create admin user

if ! wp user get "$WP_USER" --path=/var/www/html --allow-root >/dev/null 2>&1
then
	wp user create --path=/var/www/html --allow-root \
		"$WP_USER" \
		"user@example.com" \
		--user_pass="$WP_USER_PASSWORD" \
		--role=author
fi
# create normal user

exec php-fpm8.2 -F
# start PHP-FPM and making it the main with PID=1