BOX_NAME := rancheros-lite.box
ISO_NAME := rancheros-lite.iso

PACKER  := packer
VAGRANT := vagrant

RANCHEROS_BASE_VERSION := 0.1.2
DOCKER_VERSION         := 1.5.0
KERNEL_VERSION         := 3.19.2
VBOX_VERSION           := 4.3.26

box: $(BOX_NAME)

iso: $(ISO_NAME)

vbox: iso/assets/sbin/mount.vboxsf \
	iso/assets/lib/modules/vboxguest.ko iso/assets/lib/modules/vboxsf.ko

$(BOX_NAME): $(ISO_NAME) box/template.json box/vagrantfile.tpl \
	box/vagrant_plugin_guest_busybox.rb box/assets/profile box/assets/start.sh
	cd box && \
		$(PACKER) build template.json

$(ISO_NAME): iso/Dockerfile iso/assets/init iso/assets/isolinux.cfg \
	iso/os-base.tar.xz iso/docker-$(DOCKER_VERSION).tgz \
	iso/assets/sbin/mount.vboxsf \
	iso/assets/lib/modules/vboxguest.ko iso/assets/lib/modules/vboxsf.ko
	$(VAGRANT) suspend
	cd iso && \
		$(VAGRANT) up --no-provision && \
		$(VAGRANT) provision --provision-with rancheros && \
		$(VAGRANT) suspend

iso/os-base.tar.xz:
	curl -L https://github.com/ailispaw/os-base/releases/download/lite%2Fv$(RANCHEROS_BASE_VERSION)/os-base.tar.xz -o iso/os-base.tar.xz

iso/docker-$(DOCKER_VERSION).tgz:
	curl -L https://get.docker.com/builds/Linux/x86_64/docker-$(DOCKER_VERSION).tgz -o iso/docker-$(DOCKER_VERSION).tgz

iso/assets/sbin/mount.vboxsf \
iso/assets/lib/modules/vboxguest.ko \
iso/assets/lib/modules/vboxsf.ko: vboxguest/Dockerfile vboxguest/installer \
	vboxguest/linux-$(KERNEL_VERSION).tar.xz vboxguest/kernel-config vboxguest/vboxguest.iso
	$(RM) -r iso/assets/lib
	$(RM) -r iso/assets/sbin
	$(VAGRANT) suspend
	cd iso && \
		$(VAGRANT) up --no-provision && \
		$(VAGRANT) provision --provision-with vboxguest && \
		$(VAGRANT) suspend

vboxguest/linux-$(KERNEL_VERSION).tar.xz:
	curl -L https://www.kernel.org/pub/linux/kernel/v3.x/linux-$(KERNEL_VERSION).tar.xz -o vboxguest/linux-$(KERNEL_VERSION).tar.xz

vboxguest/kernel-config:
	curl -L https://raw.githubusercontent.com/ailispaw/os-base/lite/v$(RANCHEROS_BASE_VERSION)/config/kernel-config -o vboxguest/kernel-config

vboxguest/vboxguest.iso:
	curl -L http://download.virtualbox.org/virtualbox/$(VBOX_VERSION)/VBoxGuestAdditions_$(VBOX_VERSION).iso -o vboxguest/vboxguest.iso

install: $(BOX_NAME)
	$(VAGRANT) box add -f rancheros-lite $(BOX_NAME)

boot_test: install
	$(VAGRANT) destroy -f
	$(VAGRANT) up --no-provision

test: boot_test
	$(VAGRANT) provision
	@echo "-----> docker version"
	docker version
	@echo "-----> docker images -t"
	docker images -t
	@echo "-----> docker ps -a"
	docker ps -a
	@echo "-----> nc localhost 8080"
	@nc localhost 8080
	@echo "-----> hostname"
	@$(VAGRANT) ssh -c "hostname" -- -T
	@echo "-----> route"
	@$(VAGRANT) ssh -c "route" -- -T
	$(VAGRANT) suspend

clean:
	cd iso && $(VAGRANT) destroy -f
	$(RM) -r iso/.vagrant
	$(VAGRANT) destroy -f
	$(RM) -r .vagrant
	$(RM) iso/*.xz
	$(RM) iso/*.tgz
	$(RM) $(BOX_NAME)
	$(RM) $(ISO_NAME)
	$(RM) -r box/packer_cache
	$(RM) vboxguest/kernel-config
	$(RM) vboxguest/*.xz
	$(RM) vboxguest/*.iso
	$(RM) -r iso/assets/lib
	$(RM) -r iso/assets/sbin

.PHONY: box iso vbox install boot_test test clean
