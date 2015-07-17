# RancherOS Lite with xhyve

## Requirements

- [xhyve](https://github.com/mist64/xhyve)
	- Mac OS X Yosemite 10.10.3 or later
	- A 2010 or later Mac
- Other hypervisors like VirtualBox must ***NOT*** be running at the same time, or crash.

## Installing xhyve

```
$ git clone https://github.com/mist64/xhyve
$ cd xhyve
$ make
$ cp build/xhyve /usr/local/bin/ # You may need sudo.
```

## Getting RancherOS Images for xhyve

```
$ git clone https://github.com/ailispaw/rancheros-lite
$ cd rancheros-lite/contrib/xhyve
$ make
```

## Booting Up

```
$ sudo ./xhyverun.sh
Password:

RancherOS Lite: rancheros-lite /dev/ttyS0
rancheros-lite login: 
```

## Logging In

### for Console
- ID: rancher
- Password: rancher

```
RancherOS Lite: rancheros-lite /dev/ttyS0
rancheros-lite login: rancher
Password: 
[rancher@rancheros-lite ~]$ ifconfig eth0
eth0      Link encap:Ethernet  HWaddr 32:70:CB:56:CF:32
          inet addr:192.168.64.2  Bcast:192.168.64.255  Mask:255.255.255.0
          inet6 addr: fe80::e858:48d4:e359:6504/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:9 errors:0 dropped:0 overruns:0 frame:0
          TX packets:11 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:2049 (2.0 KiB)  TX bytes:1864 (1.8 KiB)

[rancher@rancheros-lite ~]$ 
```

### for SSH

Use IP address (192.168.64.X) shown avobe and insecure_private_key from Vagrant.

```
$ ssh rancher@192.168.64.2 -i insecure_private_key
[rancher@rancheros-lite ~]$ 
```

## Shutting Down

Use `halt` command.

```
[rancher@rancheros-lite ~]$ sudo halt
halt[278]: halt
reboot: System halted
$ 
```

And also you can use `shutdown`, `reboot` and `poweroff` as expected.

## Using Docker

Use IP address (192.168.64.X) shown avobe as well.

```
$ docker -H 192.168.64.2:2375 info
Containers: 0
Images: 0
Storage Driver: overlay
 Backing Filesystem: extfs
Execution Driver: native-0.2
Kernel Version: 4.0.5-rancher
Operating System: RancherOS Lite v0.5.0
CPUs: 1
Total Memory: 998.8 MiB
Name: rancheros-lite
ID: OB7B:GK3G:K7MW:HCKD:6DX6:H2X7:RFCW:LIXJ:6WD4:YJ7P:OYBA:NYGW
Debug mode (server): true
Debug mode (client): false
Fds: 11
Goroutines: 16
System Time: Sat Jun 13 05:52:52 UTC 2015
EventsListeners: 0
Init SHA1: 7f9c6798b022e64f04d2aff8c75cbf38a2779493
Init Path: /bin/docker
Docker Root Dir: /mnt/vda1/var/lib/docker
```

## Resources

- /var/db/dhcpd_leases
- /Library/Preferences/SystemConfiguration/com.apple.vmnet.plist
  - Shared_Net_Address
  - Shared_Net_Mask
