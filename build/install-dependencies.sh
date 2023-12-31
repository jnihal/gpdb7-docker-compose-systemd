#! /bin/bash

yum install -y epel-release
yum install -y emacs-nox net-tools openssh-server openssh-clients passwd iproute procps vim go sudo polkit

pip3 install psutil==5.7.0 pyyaml==5.3.1

wget https://go.dev/dl/go1.21.4.linux-amd64.tar.gz
tar -C /usr/local -xzvf go1.21.4.linux-amd64.tar.gz
rm -f go1.21.4.linux-amd64.tar.gz
