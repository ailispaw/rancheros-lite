# Talk2Docker Installer for RancherOS Lite

It will install [talk2docker](https://github.com/ailispaw/talk2docker) into /opt/bin.

## How to Install

```
$ vagrant box add ailispaw/rancheros-lite
$ vagrant init -m ailispaw/rancheros-lite
$ vagrant up
$ vagrant ssh
[rancher@rancheros-lite ~]$ wget --no-check-certificate https://raw.githubusercontent.com/ailispaw/rancheros-lite/master/contrib/talk2docker/install.sh
[rancher@rancheros-lite ~]$ chmod +x install.sh
[rancher@rancheros-lite ~]$ ./install.sh
[rancher@rancheros-lite ~]$ talk2docker version
+---------------+---------+-------------+------------+------------+-------+----------------+-------+
|               | VERSION | API VERSION | GO VERSION | GIT COMMIT |  OS   | KERNEL VERSION | ARCH  |
+---------------+---------+-------------+------------+------------+-------+----------------+-------+
| Talk2Docker   | 1.4.0   | 1.16        | go1.4.2    | bc8c9eb    | linux |                | amd64 |
| Docker Server | 1.5.0   | 1.17        | go1.4.1    | a8a31ef    | linux | 3.19.3-rancher | amd64 |
+---------------+---------+-------------+------------+------------+-------+----------------+-------+
```
