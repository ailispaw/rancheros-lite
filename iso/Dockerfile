FROM ubuntu:14.04.2

RUN apt-get update && \
    apt-get -q -y install bc xz-utils ca-certificates syslinux xorriso && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src

ENV KERNEL_VERSION 4.0.9
COPY os-base.tar.xz /usr/src/
RUN tar xJf os-base.tar.xz && \
    tar xf dist/kernel/linux-*.tar -C dist/kernel

RUN mkdir -p root && \
    cp -r dist/kernel/lib root
# Taken from boot2docker
# Remove useless kernel modules, based on unclejack/debian2docker
RUN cd root/lib/modules && \
    rm -rf ./*/kernel/build && \
    rm -rf ./*/kernel/source && \
    rm -rf ./*/kernel/sound/* && \
    rm -rf ./*/kernel/drivers/gpu/* && \
    rm -rf ./*/kernel/drivers/infiniband/* && \
    rm -rf ./*/kernel/drivers/isdn/* && \
    rm -rf ./*/kernel/drivers/media/* && \
    rm -rf ./*/kernel/drivers/staging/lustre/* && \
    rm -rf ./*/kernel/drivers/staging/comedi/* && \
    rm -rf ./*/kernel/fs/ocfs2/* && \
    rm -rf ./*/kernel/fs/reiserfs/* && \
    rm -rf ./*/kernel/net/bluetooth/* && \
    rm -rf ./*/kernel/net/mac80211/* && \
    rm -rf ./*/kernel/net/wireless/*

COPY assets/sbin/mount.vboxsf root/sbin/
COPY assets/lib/modules/*.ko root/lib/modules/${KERNEL_VERSION}-rancher/
RUN depmod -a -b /usr/src/root ${KERNEL_VERSION}-rancher

# Start assembling root
RUN tar xf dist/rootfs.tar -C root && \
    cd root && \
    rm -rf run \
      linuxrc \
      etc/os-release \
      var/cache \
      var/lock \
      var/log \
      var/run \
      var/spool \
      var/lib/misc \
      usr/share/locale && \
    mkdir -p run \
      var/cache \
      var/lock \
      var/log \
      var/run \
      var/spool

RUN mkdir -p root/etc/ssl/certs && \
    cp /etc/ssl/certs/ca-certificates.crt root/etc/ssl/certs/

# Install docker
ENV DOCKER_VERSION 1.7.1
COPY docker-$DOCKER_VERSION.tgz /usr/src/
RUN mkdir -p root/bin && \
    tar xvzf docker-$DOCKER_VERSION.tgz -C root/bin --strip-components=3

COPY assets/init /usr/src/root/
COPY assets/respawn /usr/src/root/usr/bin/
COPY assets/shutdown /usr/src/root/sbin/
RUN cd /usr/src/root/sbin/ && \
    for i in halt reboot poweroff; do \
      rm -f $i; \
      ln -s shutdown $i; \
    done

ENV ISO /usr/src/rancheros-lite

RUN mkdir -p $ISO/boot && \
    cp dist/kernel/boot/vmlinuz* $ISO/boot/vmlinuz && \
    cd root && find | cpio -H newc -o | lzma -c > $ISO/boot/initrd

RUN mkdir -p $ISO/boot/isolinux && \
    cp /usr/lib/syslinux/isolinux.bin $ISO/boot/isolinux/ && \
    cp /usr/lib/syslinux/linux.c32 $ISO/boot/isolinux/ldlinux.c32

COPY assets/isolinux.cfg $ISO/boot/isolinux/

# Copied from boot2docker, thanks.
RUN cd $ISO && \
    xorriso \
      -publisher "A.I. <ailis@paw.zone>" \
      -as mkisofs \
      -l -J -R -V "RANCHEROS_LITE" \
      -no-emul-boot -boot-load-size 4 -boot-info-table \
      -b boot/isolinux/isolinux.bin -c boot/isolinux/boot.cat \
      -isohybrid-mbr /usr/lib/syslinux/isohdpfx.bin \
      -no-pad -o /rancheros-lite.iso $(pwd)

CMD ["cat", "/rancheros-lite.iso"]
