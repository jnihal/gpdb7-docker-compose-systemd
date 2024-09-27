#! /bin/bash
set -e

cd /gpdb-src
./configure --prefix=/usr/local/greenplum-db --without-zstd --disable-gpcloud --enable-debug --enable-depend --disable-orca --with-python --enable-orafce --disable-gpfdist --enable-cassert
export GOFLAGS="-buildvcs=false"
make -j8

mkdir -p /data/qddir && chown -R gpadmin:gpadmin /data/qddir
