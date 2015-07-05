#!/bin/sh

KERNEL="vmlinuz"
INITRD="initrd"
#CMDLINE="earlyprintk=serial console=ttyS0 acpi=off"
CMDLINE="earlyprintk=serial console=ttyS0 console=tty0 quiet"

ACPI="-A"
MEM="-m 1G"
#SMP="-c 2"
NET="-s 2:0,virtio-net"
#IMG_CD="-s 3,ahci-cd,rancheros-lite.iso"
IMG_HDD="-s 4,virtio-blk,rancheros-lite-packer-disk1.raw"
PCI_DEV="-s 0:0,hostbridge -s 31,lpc"
LPC_DEV="-l com1,stdio"
UUID="-U a01fb25c-3a19-4759-a47a-2e353e51807d"

xhyve $ACPI $MEM $SMP $PCI_DEV $LPC_DEV $NET $IMG_CD $IMG_HDD $UUID -f kexec,$KERNEL,$INITRD,"$CMDLINE"
