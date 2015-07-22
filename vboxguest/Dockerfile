FROM ubuntu:14.04.2

RUN apt-get update && \
    apt-get -q -y install bc curl xz-utils build-essential p7zip-full && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV KERNEL_VERSION 4.0.9
COPY linux-${KERNEL_VERSION}.tar.xz /usr/src/
RUN cd /usr/src && \
    tar xPJf linux-${KERNEL_VERSION}.tar.xz

COPY kernel-config /usr/src/linux-${KERNEL_VERSION}/.config
RUN cd /usr/src/linux-${KERNEL_VERSION} && \
    make oldconfig && \
    make prepare && make scripts && \
    make headers_install INSTALL_HDR_PATH=/usr/src

ENV VBOX_VERSION 4.3.30
RUN mkdir -p /vboxguest
COPY vboxguest.iso /vboxguest/
RUN cd /vboxguest && \
    7z x vboxguest.iso -ir'!VBoxLinuxAdditions.run' && \
    sh VBoxLinuxAdditions.run --noexec --target . && \
    mkdir -p amd64 && tar -C amd64 -xjf VBoxGuestAdditions-amd64.tar.bz2 && \
    rm -rf amd64/src/vboxguest-${VBOX_VERSION}/vboxvideo && \
    KERN_DIR=/usr/src/linux-${KERNEL_VERSION} KERN_INCL=/usr/src/include \
        make -C amd64/src/vboxguest-${VBOX_VERSION}

COPY installer /installer
CMD /installer
