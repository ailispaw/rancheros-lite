#!/bin/sh

VERSION=1.5.0

cd /tmp

wget https://github.com/ailispaw/talk2docker/releases/download/v${VERSION}/talk2docker_${VERSION}_linux_amd64.tar.gz

tar zxf talk2docker_${VERSION}_linux_amd64.tar.gz

sudo mkdir -p /opt/bin
sudo cp talk2docker_${VERSION}_linux_amd64/talk2docker /opt/bin

rm -rf talk2docker_${VERSION}_linux_amd64*
