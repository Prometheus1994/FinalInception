# Developer Documentation

## Prerequisites

Install:

- Docker
- Docker Compose
- Make

---

## Configuration

### Environment variables

Create and configure:

```
srcs/.env
```

### Secrets

Create the following files:

```
secrets/db_password.txt
secrets/db_root_password.txt
secrets/credentials.txt
```

### Hosts

Add the following line to `/etc/hosts`:

```
127.0.0.1 ytlidi.42.fr
```

---

## Build and Launch

Build the images and start the containers:

```bash
make
```

---

## Managing the Project

Stop the project and remove the containers and network:

```bash
make clean
```

Completely remove the project (containers, network, volumes, and unused Docker resources):

```bash
make fclean
```

Rebuild the entire project:

```bash
make re
```

---

## Data Persistence

The project uses two Docker volumes.

### MariaDB

Container path:

```
/var/lib/mysql
```

Stores:

- WordPress database
- Users
- Posts
- Pages
- Comments

### WordPress

Container path:

```
/var/www/html
```

Stores:

- WordPress files
- Themes
- Plugins
- Uploads

The volumes are preserved by `make clean` and removed by `make fclean`.

## Inspecting the Database

Enter the MariaDB container:

```bash
docker exec -it srcs-mariadb-1 bash
```

Log in as the root user:

```bash
mariadb -u root -p
```

Enter the root password stored in `secrets/db_root_password.txt`.

List the databases:

```sql
SHOW DATABASES;
```

Select the WordPress database:

```sql
USE wordpress;
```

Replace `wordpress` with the value of `MYSQL_DATABASE` if different.

Verify that the database is not empty:

```sql
SHOW TABLES;
```

Display the registered WordPress users:

```sql
SELECT * FROM wp_users;
```

Display the available posts:

```sql
SELECT * FROM wp_posts;
```

Exit the MariaDB client:

```sql
EXIT;
```

Exit the container:

```bash
exit
```