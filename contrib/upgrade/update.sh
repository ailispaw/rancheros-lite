#!/bin/sh

pushd `dirname $0` > /dev/null
HERE=`pwd`
popd > /dev/null

echo "Make sure I have the latest one."
vagrant box update --box ailispaw/rancheros-lite --provider virtualbox

cd ~/.vagrant.d/boxes/ailispaw-VAGRANTSLASH-rancheros-lite

VERSION=$(ls -1r | grep -v metadata_url | head -n 1)
echo "The latest version is ${VERSION}."

cd "${HERE}"

jq -f sort.jq ~/.vagrant.d/data/machine-index/index > index.old

jq -f update.jq --arg version "${VERSION}" ~/.vagrant.d/data/machine-index/index > index.new

echo "diff index.old index.new"
if ! diff index.old index.new; then
  read -p "Are you sure to update Vagrant index file (y/n)? " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    cp ~/.vagrant.d/data/machine-index/index index.org
    jq -c -f update.jq --arg version "${VERSION}" ~/.vagrant.d/data/machine-index/index > index
    cp index ~/.vagrant.d/data/machine-index/index
    echo "The index file has been updated!"
    echo "The original index file has been saved as ${HERE}/index.org."
  else
    echo "Aborted!"
  fi
fi
