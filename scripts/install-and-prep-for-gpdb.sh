#! /bin/bash
set -e

# Setup SSH server
cat >> /etc/systemd/system/ssh.service << EOF
[Unit]
Description=SSH Server

[Service]
Type=simple
ExecStart=/usr/sbin/sshd
Restart=on-failure

[Install]
WantedBy=default.target
EOF

systemctl enable ssh.service
systemctl start ssh.service

# To enable TCP connections after reboot
cat >> /etc/systemd/system/tcp.service << EOF
[Unit]
Description=TCP Enabler

[Service]
Type=simple
ExecStart=/usr/bin/su gpadmin -c "nc -l"
Restart=on-failure

[Install]
WantedBy=default.target
EOF

systemctl enable tcp.service
systemctl start tcp.service

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
make install GOFLAGS="-buildvcs=false"

chown -R gpadmin:gpadmin /usr/local/greenplum-db/
mkdir -p /data/primary /data/mirror && chown -R gpadmin:gpadmin /data/primary /data/mirror
