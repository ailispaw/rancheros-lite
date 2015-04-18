# RancherOS Lite

RancherOS Lite is a light version of [RancherOS](https://github.com/rancherio/os) as same as [Only Docker](https://github.com/ibuildthecloud/only-docker).  
It has no system-docker containers unlike RancherOS, but it combines with them to form normal processes at the top of [RancherOS Base](https://github.com/rancherio/os-base). Therefore, it works like [boot2docker](https://github.com/boot2docker/boot2docker) and it's easy to use [Docker](https://github.com/docker/docker).

## Features

- Based on RancherOS Base with kernel v3.19.3 and buildroot/GLIBC
- 40 GB persistent disk
- Docker v1.5.0
- Support NFS synced folder
- Support VirtualBox Shared Folder
- Support Docker provisioner
- Disable TLS of Docker for simplicity
- Expose and forward the official IANA registered Docker port 2375
- Support [resize the persistent disk](https://github.com/ailispaw/rancheros-lite/tree/master/contrib/resizedisk)
- Support [upgrade and rollback](https://github.com/ailispaw/rancheros-lite/tree/master/contrib/upgrade)
- 20 MB

## Packaging

### Requirements

- [VirtualBox](https://www.virtualbox.org/)
- [Vagrant](https://www.vagrantup.com/)
- [Packer](https://packer.io/)

### Build a box

```
$ git clone https://github.com/ailispaw/rancheros-lite.git
$ cd rancheros-lite
$ make
```

## Vagrant up

```
$ vagrant box add ailispaw/rancheros-lite
$ vagrant init -m ailispaw/rancheros-lite
$ vagrant up
```

### Vagrantfile

```ruby
Vagrant.configure(2) do |config|
  config.vm.define "rancheros-lite"

  config.vm.box = "ailispaw/rancheros-lite"

  config.vm.synced_folder ".", "/vagrant"

  if Vagrant.has_plugin?("vagrant-triggers") then
    config.trigger.after [:up, :resume] do
      info "Adjusting datetime after suspend and resume."
      run_remote "sudo sntp -4sSc pool.ntp.org"
    end
  end

  # Adjusting datetime before provisioning.
  config.vm.provision :shell, run: "always" do |sh|
    sh.inline = "sntp -4sSc pool.ntp.org"
  end

  config.vm.provision :docker do |d|
    d.pull_images "busybox"
    d.run "simple-echo",
      image: "busybox",
      args: "-p 8080:8080",
      cmd: "nc -p 8080 -l -l -e echo hello world!"
  end

  config.vm.network :forwarded_port, guest: 8080, host: 8080
end
```

## License

[![CC0](http://i.creativecommons.org/p/zero/1.0/88x31.png)](http://creativecommons.org/publicdomain/zero/1.0/)  
To the extent possible under law, the person who associated CC0 with this work has waived all copyright and related or neighboring rights to this work.

- [RancherOS](https://github.com/rancherio/os) is licensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0).
- [RancherOS Base](https://github.com/rancherio/os-base) is licensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0).
- [Docker](https://github.com/docker/docker) is licensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0).
- [Vagrant](http://www.vagrantup.com/): Copyright (c) 2010-2015 Mitchell Hashimoto, under the [MIT License](https://github.com/mitchellh/vagrant/blob/master/LICENSE)
- [Packer](https://github.com/mitchellh/packer): [MPL2](https://github.com/mitchellh/packer/blob/master/LICENSE)
