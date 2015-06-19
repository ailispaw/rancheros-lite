#!/bin/sh

VERSION=1.5.0

cd /tmp

sudo wget --no-check-certificate https://github.com/ailispaw/talk2docker/releases/download/v${VERSION}/talk2docker_${VERSION}_linux_amd64.tar.gz

sudo gzip -d talk2docker_${VERSION}_linux_amd64.tar.gz
sudo tar xf talk2docker_${VERSION}_linux_amd64.tar

sudo mkdir -p /opt/bin
sudo cp talk2docker_${VERSION}_linux_amd64/talk2docker /opt/bin

sudo rm -rf talk2docker_${VERSION}_linux_amd64*
