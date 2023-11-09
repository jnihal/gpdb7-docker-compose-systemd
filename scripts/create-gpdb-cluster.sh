#! /bin/bash
set -e

su gpadmin -c "
   pushd /home/gpadmin
   bash /gpdb-scripts/generate_ssl_cert_multi_host.bash
   source /usr/local/greenplum-db/greenplum_path.sh
   gp configure --hostfile /gpdb-scripts/configs/hostfile --server-certificate /tmp/certificates/server-cert.pem --server-key /tmp/certificates/server-key.pem --ca-certificate /tmp/certificates/ca-cert.pem --ca-key /tmp/certificates/ca-key.pem
   popd
"

# Create environment file
cat > ~gpadmin/env.sh <<EOF
#! /bin/bash

source /usr/local/greenplum-db/greenplum_path.sh
export COORDINATOR_DATA_DIRECTORY=/data/primary/gpseg-1
export PGPORT=7000

EOF
