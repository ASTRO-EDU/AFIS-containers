# LAMP Docker Compose stack
Start **LAMP envinroment** via docker compose. 

define in `.env` file `COMPOSE_FILE` envvar.

- `COMPOSE_FILE=docker-compose.yml` starts production container of the kafka receiver. You need to specify kafka configuration.
- `COMPOSE_FILE=docker-compose.yml:docker-compose-dev.yml` starts development environment for kafka receiver. Sources mount is required via `KAFKA_RECEIVER_SRC_DIR`.


- `MYSQL_ROOT_PASSWORD` specifies the mysql root password.
- `AFISGUI_SRC_DIR="${HOME}/AFIS/AFIS-GUI"` specifies the sources mount point for `AFIS-GUI`.


to start compose stack:

```
cd docker-lamp
docker compose up -d
```

to stop compose 
```
docker compose down
```

to delete all the volumes:
```
docker compose down -v
```
