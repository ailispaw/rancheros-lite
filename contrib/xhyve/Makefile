all: initrd vmlinuz rancheros-lite.iso rancheros-lite-packer-disk1.raw insecure_private_key

initrd vmlinuz: rancheros-lite.iso
	hdiutil mount rancheros-lite.iso
	cp /Volumes/RANCHEROS_LITE/boot/$@ .
	hdiutil unmount /Volumes/RANCHEROS_LITE

rancheros-lite-packer-disk1.raw: rancheros-lite-packer-disk1.vmdk
	$(RM) rancheros-lite-packer-disk1.raw
	VBoxManage clonehd -format RAW rancheros-lite-packer-disk1.vmdk rancheros-lite-packer-disk1.raw

rancheros-lite.iso rancheros-lite-packer-disk1.vmdk:
	curl -OL https://github.com/ailispaw/rancheros-lite/releases/download/v0.5.0/$@

# VMDK from a box becomes a huge 40GB raw disk image.
#rancheros-lite.iso rancheros-lite-packer-disk1.vmdk: rancheros-lite.box
#	tar xmf rancheros-lite.box $@
#
#rancheros-lite.box:
#	curl -OL https://github.com/ailispaw/rancheros-lite/releases/download/v0.5.0/rancheros-lite.box

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
