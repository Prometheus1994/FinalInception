FROM debian:12

RUN apt-get update && \
	apt-get install -y php-fpm php-mysql mariadb-client curl wget
	# we added -y to automatically answer with 'y' to the question: "Do you want to continue? [Y/n]"

COPY tools/setup.sh /
	# copy setup.sh inside tools into the root directory

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

RUN chmod +x /setup.sh
	# give the permission to user to execute

ENTRYPOINT ["/setup.sh"]
	# run setup.sh when container starts