# Building on Fedora

This document provides users with step-by-step instructions on how to compile and use`mod_tile` and `renderd`.

Please see our [Continuous Integration script](/.github/workflows/build-and-test.yml) for more details.

## Fedora 34/35/36/37/38/39

```shell
#!/usr/bin/env bash

# Update installed packages
sudo dnf --assumeyes update

# Install build dependencies
# (libmemcached-devel & librados-devel are optional)
sudo dnf --assumeyes --setopt=install_weak_deps=False install \
  cairo-devel \
  cmake \
  gcc \
  gcc-c++ \
  git \
  glib2-devel \
  httpd-devel \
  iniparser-devel \
  libcurl-devel \
  libmemcached-devel \
  librados-devel \
  mapnik-devel

# Download, Build, Test & Install `mod_tile`
export CMAKE_BUILD_PARALLEL_LEVEL=$(nproc)
rm -rf /tmp/mod_tile_src /tmp/mod_tile_build
mkdir /tmp/mod_tile_src /tmp/mod_tile_build
cd /tmp/mod_tile_src
git clone --depth 1 https://github.com/openstreetmap/mod_tile.git .
cd /tmp/mod_tile_build
cmake -B . -S /tmp/mod_tile_src \
  -DCMAKE_BUILD_TYPE:STRING=Release \
  -DENABLE_TESTS:BOOL=ON
cmake --build .
ctest
sudo cmake --install . --prefix /usr --strip

# Create /usr/share/renderd directory
sudo mkdir --parents /usr/share/renderd

# Copy files of example map
sudo cp -av /tmp/mod_tile_src/utils/example-map /usr/share/renderd/example-map

# Add configuration
sudo cp -av /tmp/mod_tile_src/etc/apache2/renderd-example-map.conf /etc/httpd/conf.d/renderd-example-map.conf
printf '\n[example-map]\nURI=/tiles/renderd-example\nXML=/usr/share/renderd/example-map/mapnik.xml\n' | sudo tee -a /etc/renderd.conf

# Start services
sudo httpd
sudo renderd -f
```

Then you can visit: `http://localhost:8081/renderd-example-map`