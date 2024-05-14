# AFIS - LAMP Docker Compose

The last AFIS enviroment relies on docker compose and three different docker containers:
- `receiver` docker service for handle alerts from GCN via Kafka. based on standard linux docker image almalinux:9
- `gui` via php-apache docker service. based on docker php:8.2-apache
- `mysql` database version 8.4 .

## Build docker images:

Custom images available for receiver and gui services. 
`base` images contain only common tools between prod and sde images.
`prod` images contain built and installed code. 
`sde`  images contain only common or development tools and a non-root user. Please use ./bootstrap.sh utility to mode these images and mount source code from host.

### receiver image 

Dockerfile contains a multistage build, to build `base`, `sde` and `prod` image exec:

```
$> cd docker-lamp/receiver
$> docker compose build
```

to install a specific branch or tag on prod images :

```
$> REPO_BRANCH="dev_branch" docker compose build
```

### gui image

Dockerfile contains a multistage build, to build `base` and `prod` image exec:

```
$> cd docker-lamp/gui
$> docker compose build
```

to install a specific branch or tag on prod images :

```
$> REPO_BRANCH="dev_branch" docker compose build
```

## Start **LAMP envinroment** via docker compose. 

```
cd docker-lamp
cp template.env .env
```
edit `.env` file and choose values for `COMPOSE_FILE` envvar.

Common configuration for setting up the `prod` environment:
- `MYSQL_ROOT_PASSWORD` specifies the mysql root password.
- `MYSQL_TCP_PORT` specifies the mysql port exposed to the host, if required.

To set a `prod` deployment, use:
- `COMPOSE_FILE=docker-compose.yml` starts production containers. 
    You need to specify kafka configuration in .
    You need to mount 
- 
To set a `dev` deployment, use:
- `COMPOSE_FILE=docker-compose.yml:docker-compose-dev.yml` starts development environment. 
    clone repositories AFIS-GUI and AFIS-pipeline manually
- `AFISGUI_SRC_DIR="/path/to/AFIS-GUI"` specifies the sources mount point for `AFIS-GUI`.
- `AFISPIPE_SRC_DIR=/path/to/AFIS-pipeline`specifies the sources mount point for `AFIS-pipeline.


to start compose stack:

```
cd docker-lamp
docker compose up -d
```

to stop compose 
```
docker compose down
```

to delete all the volumes (mysql data):
```
docker compose down -v
```
