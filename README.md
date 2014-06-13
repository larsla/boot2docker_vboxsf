# boot2docker_vboxsf

## What is this?
This script+dockerfile will create a patched boot2docker.iso with support for vboxsf.
That means you can then use docker volume mapping just like you're used to when running docker in linux.

# What does it do?
It uses the boot2docker/boot2docker image from Docker Hub according to the official patching guide (https://github.com/boot2docker/boot2docker/blob/master/doc/BUILD.md#making-your-own-customised-boot2docker-iso),
downloads and installs the VBoxGuestAdditions from Virtualbox.
Then it adds a shared volume to Virtualbox that maps /Users on your host machine to /Users in the boot2docker vm.

## Update boot2docker
git clone https://github.com/larsla/boot2docker_vboxsf.git
cd boot2docker_vboxsf
vi Dockerfile     # Update VBOX_VERSION with the version of VirtualBox you're running
bash update.sh

## Using Docker volume mapping after patching is done
```
 $ cd /Users/larsla/Code/my_project
 $ docker run -i -t -v $PWD:/my_project base bash
 root@24e68e83c74f:/# df -h
 Filesystem      Size  Used Avail Use% Mounted on
 rootfs           19G  2.6G   15G  15% /
 none             19G  2.6G   15G  15% /
 tmpfs           501M     0  501M   0% /dev
 shm              64M     0   64M   0% /dev/shm
 /dev/sda1        19G  2.6G   15G  15% /.dockerinit
 /dev/sda1        19G  2.6G   15G  15% /etc/resolv.conf
 /dev/sda1        19G  2.6G   15G  15% /etc/hostname
 /dev/sda1        19G  2.6G   15G  15% /etc/hosts
 none            466G  195G  271G  42% /my_project
 tmpfs           501M     0  501M   0% /proc/kcore
 root@24e68e83c74f:/# ls /my_project
  this_is_my_project.txt
```
