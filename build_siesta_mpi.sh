#!/bin/bash

# TODO add support for different SIESTA versions
# TODO non-root default user

siesta_version=4.1-b3
siesta=siesta-$siesta_version
image_title=siesta-mpi  # Docker image name
gpgkeyid=E1D51B36       # Take Nick Papior's gpg key ID by default

echo "Building with SIESTA version: $siesta_version"
echo ""

# Download sources and signatures
wget -N https://launchpad.net/siesta/4.1/4.1-b3/+download/$siesta.tar.gz
wget -O $siesta.md5         https://launchpad.net/siesta/4.1/4.1-b3/+download/$siesta.tar.gz/+md5
wget -O $siesta.tar.gz.asc  https://launchpad.net/siesta/4.1/4.1-b3/+download/$siesta.tar.gz.asc

# Verify checksums
md5sum -c $siesta.md5
gpg --keyserver keyserver.ubuntu.com --recv-keys $gpgkeyid
gpg --verify $siesta.tar.gz.asc $siesta.tar.gz

# Build Docker image
docker build -t $image_title:$siesta_version --build-arg siesta_version=$siesta_version .
