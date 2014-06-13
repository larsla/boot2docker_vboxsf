FROM boot2docker/boot2docker:latest

ENV VBOX_VERSION 4.3.12

RUN mkdir -p /vboxguest
RUN curl -L -o /vboxguest/vboxguest.iso http://download.virtualbox.org/virtualbox/$VBOX_VERSION/VBoxGuestAdditions_$VBOX_VERSION.iso
RUN apt-get install -y p7zip-full
RUN 7z x /vboxguest/vboxguest.iso -o/vboxguest -ir'!VBoxLinuxAdditions.run'
RUN sh /vboxguest/VBoxLinuxAdditions.run --noexec --target /vboxguest
RUN mkdir /vboxguest/x86 && cd /vboxguest/x86 && tar xvjf ../VBoxGuestAdditions-x86.tar.bz2
RUN mkdir /vboxguest/amd64 && cd /vboxguest/amd64 && tar xvjf ../VBoxGuestAdditions-amd64.tar.bz2
RUN cd /vboxguest/amd64/src/vboxguest-$VBOX_VERSION && KERN_DIR=/linux-kernel/ make
RUN cp /vboxguest/amd64/src/vboxguest-$VBOX_VERSION/*.ko $ROOTFS/lib/modules/$KERNEL_VERSION-tinycore64
RUN mkdir -p $ROOTFS/sbin && cp /vboxguest/x86/lib/VBoxGuestAdditions/mount.vboxsf $ROOTFS/sbin/

RUN depmod -a -b $ROOTFS $KERNEL_VERSION-tinycore64

ADD vboxsf $ROOTFS/etc/rc.d/
RUN chmod +x $ROOTFS/etc/rc.d/vboxsf

RUN echo "/etc/rc.d/vboxsf" >>$ROOTFS/opt/bootsync.sh

RUN /make_iso.sh

#CMD ["cat", "boot2docker.iso"]
