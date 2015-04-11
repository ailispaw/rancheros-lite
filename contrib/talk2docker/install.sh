#!/bin/sh

VERSION=1.4.0

pushd `dirname $0` > /dev/null
HERE=`pwd`
popd > /dev/null

cd "${HERE}"

docker build -t curl ../curl

cd /tmp

docker run --rm -v $(pwd):/host -w /host curl -OL https://github.com/ailispaw/talk2docker/releases/download/v${VERSION}/talk2docker_${VERSION}_linux_amd64.tar.gz

sudo gzip -d talk2docker_${VERSION}_linux_amd64.tar.gz
sudo tar xf talk2docker_${VERSION}_linux_amd64.tar

sudo mkdir -p /opt/bin
sudo cp talk2docker_${VERSION}_linux_amd64/talk2docker /opt/bin

sudo rm -rf talk2docker_${VERSION}_linux_amd64*
