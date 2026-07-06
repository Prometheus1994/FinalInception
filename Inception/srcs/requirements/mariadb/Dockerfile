FROM debian:12

RUN apt-get update && \
	apt-get install -y mariadb-server mariadb-client
	# we added -y to automatically answer with 'y' to the question: "Do you want to continue? [Y/n]"

COPY tools/setup.sh /
	# copy setup.sh inside tools into the root directory

COPY conf/my.cnf /etc/mysql/my.cnf

RUN chmod +x /setup.sh
	# give the permission to user to execute

ENTRYPOINT ["/setup.sh"]
	# run setup.sh when container starts