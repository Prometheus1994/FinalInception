#!/bin/bash

set -e
# if any command failed stop script

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

mariadbd --user=mysql &
# start the server in the background and move to the next line

until mariadb-admin ping --silent
do
	sleep 1
done
# until MariaDB is alive still sleeping 

if mariadb -uroot -p"$(cat /run/secrets/db_root_password)" \
	-e "USE ${MYSQL_DATABASE};" >/dev/null 2>&1
then
	mariadb-admin -uroot -p"$(cat /run/secrets/db_root_password)" shutdown
	exec mariadbd --user=mysql
fi
# if the database is already initialized:
# - stop the temporary server
# - start MariaDB normally as PID=1

MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
MYSQL_PASSWORD=$(cat /run/secrets/db_password)

mariadb << EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF
# config database using SQL language

mariadb-admin -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown
# stop the temporary server that we initialize the database with it

exec mariadbd --user=mysql
# start the permanent server with PID=1