BOX_NAME := rancheros-lite.box
ISO_NAME := rancheros-lite.iso

PACKER  := packer
VAGRANT := vagrant

RANCHEROS_BASE_VERSION := 0.1.1
DOCKER_VERSION         := 1.5.0

box: $(BOX_NAME)

iso: $(ISO_NAME)

$(BOX_NAME): $(ISO_NAME) box/template.json box/vagrantfile.tpl \
	box/vagrant_plugin_guest_busybox.rb box/assets/profile box/assets/start.sh
	cd box && \
		$(PACKER) build template.json

$(ISO_NAME): iso/Dockerfile iso/assets/init iso/assets/isolinux.cfg \
	iso/os-base.tar.xz iso/docker-$(DOCKER_VERSION).tgz
	$(VAGRANT) suspend
	cd iso && \
		$(VAGRANT) up --no-provision && \
		$(VAGRANT) provision && \
		$(VAGRANT) suspend

iso/os-base.tar.xz:
	curl -L https://github.com/rancherio/os-base/releases/download/v$(RANCHEROS_BASE_VERSION)/os-base.tar.xz -o iso/os-base.tar.xz

iso/docker-$(DOCKER_VERSION).tgz:
	curl -L https://get.docker.com/builds/Linux/x86_64/docker-$(DOCKER_VERSION).tgz -o iso/docker-$(DOCKER_VERSION).tgz

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

.PHONY: box iso install boot_test test clean
