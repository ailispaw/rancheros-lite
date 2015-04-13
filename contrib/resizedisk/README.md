# Resize a Persistent Disk in RancherOS Lite

It will convert a persistent disk from VMDK to VDI and resize it.

## How to Use

```
$ vagrant box add ailispaw/rancheros-lite
$ vagrant init -m ailispaw/rancheros-lite
$ vagrant up
$ vagrant ssh -c 'df' -- -T
Filesystem           1K-blocks      Used Available Use% Mounted on
devtmpfs                500728         0    500728   0% /dev
none                    511384       116    511268   0% /run
none                    511384         0    511384   0% /sys/fs/cgroup
/dev/sda1             40174892     73188  38037836   0% /mnt/sda1
none                 243915264  86506552 157408712  35% /vagrant
$ curl -OL https://raw.githubusercontent.com/ailispaw/rancheros-lite/master/contrib/resizedisk/resize.sh
$ chmod +x resize.sh
$ ./resize.sh default 80000
Stopping the VM...
==> default: Attempting graceful shutdown of VM...
Replacing VMDK with VDI...
0%...10%...20%...30%...40%...50%...60%...70%...80%...90%...100%
Clone hard disk created in format 'VDI'. UUID: 3ce3aa1f-3e79-41a3-952e-c26fcea961bf
0%...10%...20%...30%...40%...50%...60%...70%...80%...90%...100%
Resizing the disk...
0%...10%...20%...30%...40%...50%...60%...70%...80%...90%...100%
Boot and Re-partitioning...
Reboot and Resizing the partition...
Complete successfully
$ vagrant ssh -c 'df' -- -T
Filesystem           1K-blocks      Used Available Use% Mounted on
devtmpfs                500728         0    500728   0% /dev
none                    511384       116    511268   0% /run
none                    511384         0    511384   0% /sys/fs/cgroup
/dev/sda1             79525444     77168  75788372   0% /mnt/sda1
none                 243915264  86576848 157338416  35% /vagrant
```

## Usage

```
$ resize.sh [name] [size]
```

- `name`:  Name of Vagrant virtual machine (a value of config.vm.define?=default)
- `size`: Size in MB which you want to resize to.  If omit, it will just convert a disk from VMDK to VDI for the future use.

**Note) You must execute it at the folder alongside Vagrantfile with the VM of `name`.**
