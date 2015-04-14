# Customize Docker Daemon

You can customize behavior of Docker Daemon by modifying `/var/lib/rancheros-lite/profile`.

Cf.) https://github.com/ailispaw/rancheros-lite/blob/master/iso/assets/init

## Default

```bash
[rancher@rancheros-lite ~]$ cat /var/lib/rancheros-lite/profile
# DOCKER_STORAGE="overlay"

# DOCKER_DIR="/var/lib/docker"

# DOCKER_HOST="-H unix://"
DOCKER_HOST="-H unix:// -H tcp://0.0.0.0:2375"

# DOCKER_EXTRA_ARGS=
```

## These variables will be used at the init process as below.

```
exec docker -d -D -s $DOCKER_STORAGE -g "$DOCKER_DIR" $DOCKER_HOST $DOCKER_EXTRA_ARGS
```

## Activate modifications

You need to reboot the VM to activate after modifications.
