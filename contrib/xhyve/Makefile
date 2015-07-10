all: initrd vmlinuz rancheros-lite-packer-disk1.raw insecure_private_key exports

initrd vmlinuz: rancheros-lite.iso
	hdiutil mount rancheros-lite.iso
	cp /Volumes/RANCHEROS_LITE/boot/$@ .
	hdiutil unmount /Volumes/RANCHEROS_LITE

rancheros-lite-packer-disk1.raw: rancheros-lite-packer-disk1.vmdk
	$(RM) rancheros-lite-packer-disk1.raw
	VBoxManage clonehd -format RAW rancheros-lite-packer-disk1.vmdk rancheros-lite-packer-disk1.raw

rancheros-lite.iso rancheros-lite-packer-disk1.vmdk:
	curl -OL https://github.com/ailispaw/rancheros-lite/releases/download/v0.6.3/$@

# VMDK from a box becomes a huge 40GB raw disk image.
#rancheros-lite.iso rancheros-lite-packer-disk1.vmdk: rancheros-lite.box
#	tar xmf rancheros-lite.box $@
#
#rancheros-lite.box:
#	curl -OL https://github.com/ailispaw/rancheros-lite/releases/download/v0.6.3/rancheros-lite.box

insecure_private_key:
	curl -L https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant \
		-o insecure_private_key
	chmod 0600 insecure_private_key

clean:
	$(RM) initrd vmlinuz
	$(RM) insecure_private_key
	$(RM) rancheros-lite.iso
	$(RM) rancheros-lite-packer-disk1.raw
	$(RM) rancheros-lite-packer-disk1.vmdk
#	$(RM) rancheros-lite.box

.PHONY: all clean

UID = $(shell id -u)
GID = $(shell id -g)
USERS = /Users -network 192.168.64.0 -mask 255.255.255.0 -alldirs -mapall=$(UID):$(GID)

exports:
	@sudo touch /etc/exports
	@if ! grep -qs '^$(USERS)$$' /etc/exports; \
	then \
		echo '$(USERS)' | sudo tee -a /etc/exports; \
	fi;
	sudo nfsd restart

exports-clean:
	@sudo touch /etc/exports
	sudo sed -E -e '/^\$(USERS)$$/d' -i.bak /etc/exports
	sudo nfsd restart

.PHONY: exports exports-clean
