#!/usr/bin/env bash
# Ubuntu 20.04/22.04

# Update installed packages
# sudo apt update && sudo apt --yes upgrade
# sudo apt --yes install --reinstall ca-certificates

# Install build dependencies
# (libmemcached-dev & librados-dev are optional)
sudo apt --no-install-recommends --yes install \
  apache2 \
  apache2-dev \
  cmake \
  curl \
  g++ \
  gcc \
  git \
  libcairo2-dev \
  libcurl4-openssl-dev \
  libglib2.0-dev \
  libiniparser-dev \
  libmapnik-dev \
  libmemcached-dev \
  librados-dev \
  libs3-dev

# Download, Build, Test & Install `mod_tile`
export CMAKE_BUILD_PARALLEL_LEVEL=$(nproc)
export TMP=/u2/tmp
rm -rf $TMP/mod_tile_src $TMP/mod_tile_build
mkdir $TMP/mod_tile_src $TMP/mod_tile_build
cd $TMP/mod_tile_src
git clone --depth 1 https://github.com/openstreetmap/mod_tile.git .
cd $TMP/mod_tile_build
cmake -B . -S $TMP/mod_tile_src \
  -DCMAKE_BUILD_TYPE:STRING=Release \
  -DCMAKE_INSTALL_LOCALSTATEDIR=/var \
  -DCMAKE_INSTALL_PREFIX=/usr \
  -DCMAKE_INSTALL_RUNSTATEDIR=/run \
  -DCMAKE_INSTALL_SYSCONFDIR=/etc \
  -DENABLE_TESTS:BOOL=ON
cmake --build .
#ctest