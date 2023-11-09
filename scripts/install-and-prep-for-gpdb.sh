#! /bin/bash
set -e

# Install GPDB
if [ $1 == "rpm" ]; then
    yum -y install /gpdb-rpm/greenplum-db-*.rpm
    chown -R gpadmin:gpadmin /usr/local/greenplum-db-*
else
    cd /gpdb-src
    make install
fi

# Source GPDB and install pygresql
source /usr/local/greenplum-db/greenplum_path.sh
pip3 install psycopg2-binary

# Install gp binary
cd /gpdb-src/gpMgmt/bin/go-tools
make install

# Start sshd server
/usr/sbin/sshd

loginctl enable-linger gpadmin

chown -R gpadmin:gpadmin /usr/local/greenplum-db/
mkdir -p /data/primary /data/mirror && chown -R gpadmin:gpadmin /data/primary /data/mirror
