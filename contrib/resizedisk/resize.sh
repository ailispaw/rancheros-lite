#!/bin/bash

GREEN="[38;5;2m"
RED="[38;5;1m"
CLEAR="[39m"

print_usage() {
  echo "Usage: $(basename $0) [Vagrant Machine Name (config.vm.define?=default)] [Size in MB]"
  if [ -n "$1" ] ; then
    echo
    echo -e "${RED}$1${CLEAR}"
  fi
}

# Check parameters
NAME="default"
SIZE=""
if [ -n "$1" ] ; then
  if expr "$1" : '[0-9]*' > /dev/null ; then
    NAME="default"
    SIZE="$1"
  else
    NAME="$1"
  fi
fi
if [ -n "$2" ] ; then
  if expr "$2" : '[0-9]*' > /dev/null ; then
    SIZE="$2"
  else
    print_usage "The Size parameter must be a numeric value in MB." >&2
    exit 1
  fi
fi

# Get UUID of VM
ID_FILE="./.vagrant/machines/${NAME}/virtualbox/id"
if [ ! -f "${ID_FILE}" ] ; then
  print_usage "Please execute in the folder alongside Vagrantfile with \"${NAME}\"." >&2
  exit 1
fi
UUID=$(cat ${ID_FILE})

# Get VMDK
VMDK_DISK_PATH=""
output=$(VBoxManage showvminfo ${UUID} --machinereadable | grep "SATA Controller-0-0")
pattern='^"SATA Controller-0-0"="(.+)"'
if [[ "${output}" =~ ${pattern} ]] ; then
  VMDK_DISK_PATH=${BASH_REMATCH[1]}
fi
if [ -z "${VMDK_DISK_PATH}" -o "${VMDK_DISK_PATH}" == "none" ] ; then
  print_usage "No HDD in the machine \"${NAME}\"." >&2
  exit 1
fi

# Set VDI
VDI_DISK_PATH="${VMDK_DISK_PATH%.*}.vdi"

DONE=false

if [ "${VMDK_DISK_PATH}" != "${VDI_DISK_PATH}" ] ; then
  echo -e "${GREEN}Stopping the VM...${CLEAR}"
  # Resume VM if it's suspended. Otherwise, the pertition may be broken.
  vagrant resume "${NAME}" > /dev/null 2>&1
  vagrant halt "${NAME}"
  # Must wait to shutdown completely
  sleep 5

  echo -e "${GREEN}Replacing VMDK with VDI...${CLEAR}"
  # Convert VMDK to VDI
  VBoxManage clonehd "${VMDK_DISK_PATH}" "${VDI_DISK_PATH}" --format VDI --variant Standard

  # Detach VMDK
  VBoxManage storageattach "${UUID}" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium none

  # Delete VMDK
  VBoxManage closemedium disk "${VMDK_DISK_PATH}" --delete

  # Attach VDI
  VBoxManage storageattach "${UUID}" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "${VDI_DISK_PATH}"

  DONE=true
fi

if [ -n "${SIZE}" ] ; then
  if ! $DONE ; then
    echo -e "${GREEN}Stopping the VM...${CLEAR}"
    # Resume VM if it's suspended. Otherwise, the pertition may be broken.
    vagrant resume "${NAME}" > /dev/null 2>&1
    vagrant halt "${NAME}"
    # Must wait to shutdown completely
    sleep 5
  fi

  echo -e "${GREEN}Resizing the disk...${CLEAR}"
  VBoxManage modifyhd "${VDI_DISK_PATH}" --resize "${SIZE}"
  if [ $? -ne 0 ] ; then
    print_usage "You may set a wrong number as the Size parameter. It can't shrink a disk." >&2
    exit 1
  fi

  echo -e "${GREEN}Boot and Re-partitioning...${CLEAR}"
  vagrant up "${NAME}" > /dev/null
  vagrant ssh -c "sudo umount -l /mnt/sda1; (echo d; echo 1; echo w) | sudo fdisk /dev/sda; (echo n; echo p; echo 1; echo; echo; echo w) | sudo fdisk /dev/sda" "${NAME}" > /dev/null 2>&1

  echo -e "${GREEN}Reboot and Resizing the partition...${CLEAR}"
  vagrant reload "${NAME}" > /dev/null
  vagrant ssh -c "sudo resize2fs /dev/sda1" > /dev/null 2>&1

  DONE=true
fi

if $DONE ; then
  vagrant up "${NAME}" > /dev/null
  echo -e "${GREEN}Complete successfully${CLEAR}"
else
  echo -e "${RED}Nothing to do${CLEAR}" >&2
  exit 1
fi
