# RancherOS Lite

RancherOS Lite is a light version of [RancherOS](https://github.com/rancherio/os) as same as [Only Docker](https://github.com/ibuildthecloud/only-docker).  
It has no system-docker containers unlike RancherOS, but it combines with them to form normal processes at the top of [RancherOS Base](https://github.com/rancherio/os-base). Therefore, it works like [boot2docker](https://github.com/boot2docker/boot2docker) and it's easy to use [Docker](https://github.com/docker/docker).

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

## Vagrantfile

```
module VagrantPlugins
  module GuestLinux
    class Plugin < Vagrant.plugin("2")
      guest_capability("linux", "change_host_name") do
        Cap::ChangeHostName
      end

      guest_capability("linux", "configure_networks") do
        Cap::ConfigureNetworks
      end
    end
  end
end

Vagrant.configure(2) do |config|
  config.vm.define "rancheros-lite"

  config.vm.box = "ailispaw/rancheros-lite"

  config.vm.hostname = "rancheros-lite"

  config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.synced_folder ".", "/vagrant", type: "nfs", mount_options: ["nolock", "vers=3", "udp"]

  if Vagrant.has_plugin?("vagrant-triggers") then
    config.trigger.after [:up, :resume] do
      info "Adjusting datetime after suspend and resume."
      run_remote "sudo ntpd -n -q -g -I eth0 > /dev/null; date"
    end
  end

  # Adjusting datetime before provisioning.
  config.vm.provision :shell, run: "always" do |sh|
    sh.inline = "sudo ntpd -n -q -g -I eth0 > /dev/null; date"
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
