all: initrd vmlinuz rancheros-lite-packer-disk1.raw insecure_private_key exports

initrd vmlinuz: rancheros-lite.iso
	hdiutil mount rancheros-lite.iso
	cp /Volumes/RANCHEROS_LITE/boot/$@ .
	hdiutil unmount /Volumes/RANCHEROS_LITE

rancheros-lite-packer-disk1.raw: rancheros-lite-packer-disk1.tar.gz
	tar zxvf rancheros-lite-packer-disk1.tar.gz

rancheros-lite.iso rancheros-lite-packer-disk1.tar.gz:
	curl -OL https://github.com/ailispaw/rancheros-lite/releases/download/v0.7.3/$@

insecure_private_key:
	curl -L https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant \
		-o insecure_private_key
	chmod 0600 insecure_private_key

clean:
	$(RM) initrd vmlinuz
	$(RM) insecure_private_key
	$(RM) rancheros-lite.iso
	$(RM) rancheros-lite-packer-disk1.raw
	$(RM) rancheros-lite-packer-disk1.tar.gz

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
