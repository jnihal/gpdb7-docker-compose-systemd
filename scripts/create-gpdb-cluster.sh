#! /bin/bash
set -e

su gpadmin -c "
   pushd /home/gpadmin
   bash /gpdb-scripts/generate_ssl_cert_multi_host.bash
   source /usr/local/greenplum-db/greenplum_path.sh
   gpservice init --hostfile /gpdb-scripts/configs/hostfile --server-certificate /tmp/certificates/server-cert.pem --server-key /tmp/certificates/server-key.pem --ca-certificate /tmp/certificates/ca-cert.pem
   popd
"

# Create environment file
cat > ~gpadmin/env.sh <<EOF
#! /bin/bash

source /usr/local/greenplum-db/greenplum_path.sh
export COORDINATOR_DATA_DIRECTORY=/data/primary/gpseg-1
export PGPORT=7000

install_gp() {
# Compile gp binary
pushd /gpdb-src/gpMgmt/bin/go-tools
make build
popd

# Install gp binary on all hosts
gpservice delete
gpssh -f /gpdb-scripts/configs/hostfile 'source /usr/local/greenplum-db/greenplum_path.sh; pushd /gpdb-src/gpMgmt/bin/go-tools; make install'
gpservice init --hostfile /gpdb-scripts/configs/hostfile --server-certificate /tmp/certificates/server-cert.pem --server-key /tmp/certificates/server-key.pem --ca-certificate /tmp/certificates/ca-cert.pem
gpservice start
}

EOF
