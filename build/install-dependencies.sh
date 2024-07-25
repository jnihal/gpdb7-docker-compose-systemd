#! /bin/bash

set -euxo pipefail

yum install -y epel-release
yum install -y emacs-nox net-tools openssh-server openssh-clients passwd iproute procps vim sudo polkit nc

pip3 install psutil==5.7.0

# if golang is not installed or it's not the expected version, install the expected version
GO_VERSION=1.21.4

ARCH="amd64"
if [[ $(arch) == "aarch64" ]]; then
    ARCH="arm64"
fi

if ! command -v go &> /dev/null || ! $(go version | grep -q ${GO_VERSION}); then
    wget https://storage.googleapis.com/golang/go${GO_VERSION}.linux-${ARCH}.tar.gz
    rm -rf /usr/local/go && tar -xzf go${GO_VERSION}.linux-${ARCH}.tar.gz -C /usr/local
fi
