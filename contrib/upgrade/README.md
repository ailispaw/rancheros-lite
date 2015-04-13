# Upgrade RancherOS Lite

## How to Upgrade

```
# Make sure you have the latest version of the box.
$ vagrant box update --box ailispaw/rancheros-lite --provider virtualbox
# If you've suspended the target VM, you need to resume it not to break the persistent disk.
$ vagrant resume
$ vagrant reload
```

You don't need to recreate a VM, because the VM will mount the new ISO in the new version of the box automatically during `vagrant reload`.  
But you need to update `~/.vagrant.d/data/machine-index/index` file manually.  
(You can leave it, but you will get notifications on `vagrant box remove`.)

### How to Check the Index file

#### Requierments

- [git](http://git-scm.com/) to get tools
- [jq](http://stedolan.github.io/jq/) to parse the index file

```
$ git clone https://github.com/ailispaw/rancheros-lite
$ cd rancheros-lite/contrib/upgrade
$ ./check.sh
Make sure I have the latest one.
Checking for updates to 'ailispaw/rancheros-lite'
Latest installed version: 0.2.5
Version constraints: > 0.2.5
Provider: virtualbox
Box 'ailispaw/rancheros-lite' (v0.2.5) is running the latest version.
The latest version is 0.2.5.
No need to update.
```

## How to Rollback or Specify the particular version to boot

You can set `config.vm.box_version` as below and `vagrant reload`.

```ruby
Vagrant.configure(2) do |config|
  config.vm.box = "ailispaw/rancheros-lite"

  config.vm.box_version = "0.2.3"
end
```

```
# If you've suspended the target VM, you need to resume it not to break the persistent disk.
$ vagrant resume
$ vagrant reload
```