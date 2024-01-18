#! /bin/bash

yum install -y epel-release
yum install -y emacs-nox net-tools openssh-server openssh-clients passwd iproute procps vim sudo polkit

pip3 install psutil==5.7.0 pyyaml==5.3.1

# if golang is not installed or it's not the expected version, install the expected version
GO_VERSION=1.21.4
if ! command -v go &> /dev/null || ! $(go version | grep -q ${GO_VERSION}); then
wget https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -xzf go${GO_VERSION}.linux-amd64.tar.gz -C /usr/local
fi
