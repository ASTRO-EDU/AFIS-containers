##########################################################################################
### Phase 1: SDE image. Development enviroment with no source code installed
##########################################################################################
FROM php:8.2-apache AS base


LABEL author="nicolo.parmiggiani@inaf.it, luca.castaldini@inaf.it" \
      version="1.0.0" \
      help="Build this Dockerfile with: \n    > docker build --build-arg -t afis_gui_base ."

RUN docker-php-ext-install pdo_mysql && ln -s /tmp/ /var/www/html/tmp && apt-get update && apt-get install -y vim

ARG USER_ID=1000
RUN usermod -u "${USER_ID}" www-data

##########################################################################################
### Phase 2: Prod image. Enviroment with source code installed
##########################################################################################
FROM afis_gui_base AS prod

RUN apt-get install -y git 
LABEL author="nicolo.parmiggiani@inaf.it, luca.castaldini@inaf.it" \
      version="1.0.0" \
      help="Build this Dockerfile with: \n    > docker build --build-arg -t afis_gui_prod ."

ARG REPO_BRANCH=master
ARG REPO_SRC=https://github.com/ASTRO-EDU/AFIS-GUI.git

RUN git clone --recurse-submodules --branch ${REPO_BRANCH} ${REPO_SRC} afisgui
