##########################################################################################
### Phase 1: Common Base
##########################################################################################
FROM almalinux:9 AS base

LABEL author="luca.castaldini@inaf.it, leonardo.baroncelli@inaf.it" \
      version="1.0.0" \
      help="Build this Dockerfile with: \n    > docker build -t basic_layer_for_kafka_receiver ."

# Install dependencies and Python 3.11.11
RUN dnf update -y && \
    dnf -y install wget make gcc openssl-devel git bzip2-devel readline-devel libffi-devel gsl-devel xz-devel sqlite-devel which zlib-devel && \
    dnf install -y gcc-toolset-12 && \
    echo "source /opt/rh/gcc-toolset-12/enable" >> /etc/profile.d/gcc-toolset-12.sh && \
    source /opt/rh/gcc-toolset-12/enable && \
    cd /usr/src && \
    wget https://www.python.org/ftp/python/3.11.11/Python-3.11.11.tar.xz && \
    tar -xvf Python-3.11.11.tar.xz && \
    cd Python-3.11.11 && \
    ./configure --enable-optimizations --prefix=/opt/python3 && \
    make altinstall && \
    rm -f /usr/bin/python3 && \
    ln -s /opt/python3/bin/python3.11 /usr/bin/python3 && \
    ln -s /opt/python3/bin/python3.11 /usr/bin/python && \
    ln -s /opt/python3/bin/pip3.11 /usr/bin/pip3 && \
    ln -s /opt/python3/bin/pip3.11 /usr/bin/pip && \
    /usr/bin/python3 -m pip install --upgrade pip && \
    dnf clean all && \
    rm -rf /usr/src/Python-3.11.11 /usr/src/Python-3.11.11.tar.xz

# Set environment variables
ENV PATH=/opt/python3/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV LD_LIBRARY_PATH=/opt/rh/gcc-toolset-12/root/usr/lib64


##########################################################################################
### Phase 2: SDE image. Development enviroment with no source code installed but development tools
##########################################################################################
FROM basic_layer_for_kafka_receiver:latest AS sde

LABEL author="luca.castaldini@inaf.it" \
      version="1.0.0" \
      help="Build this Dockerfile with: \n    > docker build -t rta_transient_kafka_receiver_sde .>"

# Creazione dell'utente e configurazione sudo
RUN useradd -m -s /bin/bash gamma && \
    dnf install -y sudo && \
    echo "gamma ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Installazione dei tool di sviluppo e Python
RUN dnf install -y \
        vim \
        nano \
        unzip \
        net-tools \
        iproute \
        hostname && \
    pip install --upgrade pip setuptools wheel && \
    pip install pylint black mypy flake8 autopep8

RUN wget https://dev.mysql.com/get/mysql84-community-release-el9-1.noarch.rpm && \
    dnf localinstall -y mysql84-community-release-el9-1.noarch.rpm && \
    dnf install -y mysql-community-client

# Imposta l'utente e la directory di lavoro
USER gamma
ENV wrkdir=/home/gamma/src
WORKDIR $wrkdir

# Crea la directory di lavoro
RUN mkdir -p "$wrkdir"


# Comando di default e informazioni
CMD ["echo 'Starting instance: $(date)'"]

##########################################################################################
### Phase 3: Prod image. Enviroment with source code installed and minimal deps
##########################################################################################
FROM basic_layer_for_kafka_receiver:latest AS prod

LABEL author="leonardo.baroncelli@inaf.it, luca.castaldini@inaf.it, luca.babboni2@studio.unibo.it" \
      version="1.0.0" \
      help="Build this Dockerfile with: \n    > docker build --build-arg -t rta_transient_kafka_receiver_prod ."


ARG REPO_BRANCH=main
ARG REPO_SRC=https://github.com/ASTRO-EDU/AFIS-pipeline.git

RUN python -m pip install --upgrade pip && \
    git clone --recurse-submodules --branch ${REPO_BRANCH} ${REPO_SRC} && \
    cd AFIS-pipeline/rta-transient-receiver-kafka && \
    pip install -r rta-transient-receiver/requirements.lock && \
    pip install -r requirements.txt && \
    pip install -e rta-transient-receiver/ && \
    pip install -e .

RUN mkdir -p /etc/kafkareceiver/conf.d && \
    mkdir -p /var/log/kafkareceiver && \
    chmod -R 755 /etc/kafkareceiver /var/log/kafkareceiver

ENV RECEIVER_LOG_LEVEL=INFO
ENV RECEIVER_LOG_MODE=FILE

WORKDIR /var/log/kafkareceiver

ENTRYPOINT ["/bin/bash", "-c", "kafkareceiver --config-file /etc/kafkareceiver/conf.d/config.json --log-file receiver_$(date +\"%Y_%m_%d__%H:%M:%S\").log"]

# CMD ["echo 'Starting instance: $(date)'"]


