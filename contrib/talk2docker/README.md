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
| Talk2Docker   | 1.5.0   | 1.16        | go1.4.2    | f168e23    | linux |                | amd64 |
| Docker Server | 1.7.0   | 1.19        | go1.4.2    | 0baf609    | linux | 4.0.5-rancher  | amd64 |
+---------------+---------+-------------+------------+------------+-------+----------------+-------+```
