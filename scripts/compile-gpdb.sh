#! /bin/bash
set -e

cd /gpdb-src
./configure --prefix=/usr/local/greenplum-db --without-zstd --disable-gpcloud --enable-debug --enable-depend --disable-orca --with-python --enable-orafce --disable-gpfdist --enable-cassert
make -j8

# Compile gp binary
cd /gpdb-src/gpMgmt/bin/go-tools
make build GOFLAGS="-buildvcs=false"

mkdir -p /data/qddir && chown -R gpadmin:gpadmin /data/qddir
