FROM debian:jessie-slim

LABEL version="1.0"
ARG siesta_version

ENV SIESTA_VERSION=$siesta_version
ARG siesta=siesta-$siesta_version

WORKDIR /opt
ADD ./$siesta.tar.gz .

WORKDIR /opt/$siesta/Obj
ADD arch.make ./

# Install required packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    gfortran make ssh \
    openmpi-common openmpi-bin libopenmpi-dev libblacs-openmpi1 \
    libopenmpi1.6 libnetcdf-dev netcdf-bin \
    libscalapack-openmpi1 libscalapack-mpi-dev \
    libblas-common libblas-dev liblapack-dev libhdf5-dev \
    && ../Src/obj_setup.sh \
    && make \
    && cp siesta /usr/local/bin/siesta \
    && rm -rf /var/lib/apt/lists/*
    # && groupadd -r siesta && useradd --no-log-init -m -r -g siesta siesta \

# USER siesta
WORKDIR /home/siesta
