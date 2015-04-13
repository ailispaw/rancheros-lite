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

if ! diff index.old index.new > /dev/null; then
  jq -f check.jq --arg version "${VERSION}" ~/.vagrant.d/data/machine-index/index
  echo "Need to reboot the above vm(s) and update the index file."
  echo "Do 'vagrant reload' for the above vm(s) and run '${HERE}/update.sh'."
else
  echo "No need to update."
fi
