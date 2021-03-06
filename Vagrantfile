Vagrant.configure(2) do |config|
  config.vm.define "rancheros-lite-test"

  config.vm.box = "rancheros-lite"

  config.vm.hostname = "rancheros-lite-test.example.com"

  config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.synced_folder ".", "/vagrant"
# config.vm.synced_folder ".", "/vagrant", type: "nfs", mount_options: ["nolock", "vers=3", "udp"]

  config.vm.provider :virtualbox do |vb|
    vb.name = "rancheros-lite-test"
    vb.gui = true
  end

  if Vagrant.has_plugin?("vagrant-triggers") then
    config.trigger.after [:up, :resume] do
      info "Adjusting datetime after suspend and resume."
      run_remote "sudo sntp -4sSc pool.ntp.org; date"
    end
  end

  # Adjusting datetime before provisioning.
  config.vm.provision :shell, run: "always" do |sh|
    sh.inline = "sntp -4sSc pool.ntp.org; date"
  end

  config.vm.provision :docker do |d|
    d.pull_images "busybox"
    d.run "simple-echo",
      image: "busybox",
      args: "-p 8080:8080 --restart=always",
      cmd: "nc -p 8080 -l -l -e echo hello world!"
  end

  config.vm.network :forwarded_port, guest: 8080, host: 8080
end
