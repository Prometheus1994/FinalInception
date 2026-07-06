# User Documentation

## Overview

This project deploys a complete WordPress website using Docker Compose. The stack consists of the following services:

- **Nginx**
  - HTTPS web server.
  - Serves the WordPress website.
  - Forwards PHP requests to PHP-FPM.

- **WordPress**
  - Content Management System (CMS).
  - Executes PHP code using PHP-FPM.
  - Connects to the MariaDB database.

- **MariaDB**
  - Stores the WordPress database, including users, posts, pages, comments, and settings.

---

## Starting the Project

Build the Docker images and start all services:

```bash
make
```

---

## Stopping the Project

Stop the project and remove the containers:

```bash
make clean
```

To completely remove the project, including volumes and Docker resources:

```bash
make fclean
```

To rebuild everything from scratch:

```bash
make re
```

---

## Accessing the Website

After the project is running, open:

```
https://ytlidi.42.fr
```

---

## Accessing the Administration Panel

Open:

```
https://ytlidi.42.fr/wp-admin
```

Log in using the administrator credentials.

---

## Credentials

The project stores secrets inside the `secrets/` directory.

- `db_password.txt`
  - WordPress database user password.

- `db_root_password.txt`
  - MariaDB root password.

- `credentials.txt`
  - Line 1: WordPress administrator password.
  - Line 2: WordPress normal user password.

Usernames are configured in `srcs/.env`.

---

## Checking that the Services are Running

Display the running containers:

```bash
docker compose -f srcs/docker-compose.yml ps
```

The following services should be running:

- mariadb
- wordpress
- nginx

You can also verify that the website is available by opening:

```
https://ytlidi.42.fr
```

or by checking the logs:

```bash
docker compose -f srcs/docker-compose.yml logs
```