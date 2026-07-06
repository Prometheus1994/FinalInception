*This project has been created as part of the 42 curriculum by ytlidi*

## Description

In this project we will learn about docker and its components as images, containers, volumes, and networks.

## Instructions

* Build images and run containers: `make`

* Remove containers and networks: `make clean`

* Remove images and containers and networks and volumes: `make fclean`

* Remove images and containers and networks and volumes then rebuild images and run containers: `make re`

## Ressources

#### Classic references

[The Only Docker Tutorial You Need To Get Started](https://www.youtube.com/watch?v=DQdB7wFEygo)

[كيف غيرت ال containers بناء البرمجيات عالميا | كورس دوكر | Docker - Containers - Images - Volumes](https://www.youtube.com/watch?v=Xnu-zoqopNM)

[Docker and Kubernetes | العلبة دي فيها سوعبان](https://www.youtube.com/watch?v=PrusdhS2lmo)

#### How AI used

* AI explained Docker concepts and the project architecture.
* AI helped write and refine setup.sh scripts and configuration files.
* AI helped debug issues such as the WordPress database connection and 502 Bad Gateway.
* AI helped writing USER_DOC.md and DEV_DOC.md and also Project Description section from README.md

## Project Description

This project consists of deploying a complete WordPress website using Docker. The
application is split into multiple containers, each responsible for a single service:

- **NGINX**: Web server that serves the website over HTTPS using TLS.
- **WordPress + PHP-FPM**: Runs the WordPress application and processes PHP requests.
- **MariaDB**: Stores the website's data (users, posts, settings, etc.).

The containers communicate through a dedicated Docker network while keeping their
responsibilities isolated. Persistent data is stored in Docker volumes to ensure that
database and website files remain available even if containers are recreated.

The project also uses Docker secrets to securely provide sensitive information such as
database passwords without embedding them into Docker images or exposing them as
environment variables.

### Main Design Choices

- One service per container to follow Docker best practices.
- Debian 12 as the base image for all containers.
- Docker Compose to orchestrate the services.
- NGINX configured with TLS to provide secure HTTPS access.
- PHP-FPM separated from NGINX to keep the web server and PHP runtime independent.
- MariaDB initialized automatically during container startup.
- Docker named volumes used for persistent storage.
- Docker secrets used for passwords and other sensitive credentials.
- Environment variables used only for non-sensitive configuration.

## Design Comparisons

### Virtual Machines vs Docker

| Virtual Machines | Docker |
|------------------|---------|
| Virtualize an entire operating system. | Virtualize applications using containers. |
| Require a guest OS for each VM. | Share the host kernel. |
| Larger disk usage and memory consumption. | Lightweight and efficient. |
| Slower startup time. | Containers start in seconds. |
| Better suited for running different operating systems. | Better suited for deploying isolated applications on the same operating system. |

For this project, Docker is preferred because it provides lightweight, reproducible,
and isolated environments while consuming fewer resources than virtual machines.

### Secrets vs Environment Variables

| Docker Secrets | Environment Variables |
|----------------|-----------------------|
| Intended for sensitive information. | Intended for general configuration. |
| Stored as files inside `/run/secrets`. | Exposed as process environment variables. |
| Less likely to be exposed accidentally. | Easier to inspect and leak. |
| Suitable for passwords and private keys. | Suitable for hostnames, ports, and application settings. |

In this project:

- Docker secrets store database passwords.
- Environment variables store values such as the database name, usernames, and domain name.

### Docker Network vs Host Network

| Docker Network | Host Network |
|----------------|--------------|
| Containers communicate through an isolated virtual network. | Containers share the host's network stack. |
| Containers are reachable using their service names. | Containers use the host's interfaces directly. |
| Better isolation and security. | Higher performance but less isolation. |
| Recommended for multi-container applications. | Mainly useful for specific networking requirements. |

This project uses Docker's bridge network created by Docker Compose. Services communicate
internally using their service names (for example, `wordpress` connects to `mariadb`).

### Docker Volumes vs Bind Mounts

| Docker Volumes | Bind Mounts |
|----------------|-------------|
| Managed by Docker. | Directly reference directories on the host. |
| Portable and independent of the host filesystem layout. | Depend on a specific host path. |
| Intended for persistent application data. | Useful during development for sharing source files. |
| Easier to back up and manage with Docker. | Give direct access to host files. |

This project stores persistent website and database data using Docker named volumes,
ensuring that data survives container recreation while remaining managed by Docker.