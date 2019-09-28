#!/bin/bash  
#=================================================================================== 
# 
# Booting a Linux system involves several tasks. The process must mount both virtual and real
# file systems, initialize devices, activate swap, check file systems for integrity, mount any 
# swap partitions or files, set the system clock, bring up networking, start any daemons 
# required by the system, and accomplish any other custom tasks needed by the user. This 
# process must be organized to ensure the tasks are performed in the correct order but, at the 
# same time, be executed as fast as possible.
# Copyright (C) 2019 
 
# This program is free software: you can redistribute it and/or modify 
# it under the terms of the GNU Affero General Public License as published 
# by the Free Software Foundation, either version 3 of the License, or 
# (at your option) any later version. 
 
# This program is distributed in the hope that it will be useful, 
# but WITHOUT ANY WARRANTY; without even the implied warranty of 
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
# GNU Affero General Public License for more details. 
 
# You should have received a copy of the GNU Affero General Public License 
# along with this program.  If not, see <https://www.gnu.org/licenses/> 
# 
#===================================================================================

cd /sources
tar xvf lfs-bootscripts-20190524.tar.xz
cd lfs-bootscripts-20190524
make install
cd /sources
bash /lib/udev/init-net-rules.sh
cat /etc/udev/rules.d/70-persistent-net.rules
cd /etc/sysconfig/
cat > ifconfig.enp0s3 << "EOF"
ONBOOT=yes
IFACE=enp0s3
SERVICE=ipv4-static
IP=192.168.1.2
GATEWAY=192.168.1.1
PREFIX=24
BROADCAST=192.168.1.255
EOF
cat > /etc/resolv.conf << "EOF"
# Begin /etc/resolv.conf
nameserver 1.1.1.1
nameserver 1.0.0.1
# End /etc/resolv.conf
EOF

echo "lfs-9.0" > /etc/hostname
cat > /etc/hosts << "EOF"
# Begin /etc/hosts
127.0.0.1 localhost
::1 localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
# End /etc/hosts
EOF

cat > /etc/inittab << "EOF"
# Begin /etc/inittab
id:3:initdefault:
si::sysinit:/etc/rc.d/init.d/rc S
l0:0:wait:/etc/rc.d/init.d/rc 0
l1:S1:wait:/etc/rc.d/init.d/rc 1
l2:2:wait:/etc/rc.d/init.d/rc 2
l3:3:wait:/etc/rc.d/init.d/rc 3
l4:4:wait:/etc/rc.d/init.d/rc 4
l5:5:wait:/etc/rc.d/init.d/rc 5
l6:6:wait:/etc/rc.d/init.d/rc 6
ca:12345:ctrlaltdel:/sbin/shutdown -t1 -a -r now
su:S016:once:/sbin/sulogin
1:2345:respawn:/sbin/agetty --noclear tty1 9600
2:2345:respawn:/sbin/agetty tty2 9600
3:2345:respawn:/sbin/agetty tty3 9600
4:2345:respawn:/sbin/agetty tty4 9600
5:2345:respawn:/sbin/agetty tty5 9600
6:2345:respawn:/sbin/agetty tty6 9600
# End /etc/inittab
EOF

cat > /etc/sysconfig/clock << "EOF"
# Begin /etc/sysconfig/clock
UTC=1
# Set this to any options you might need to give to hwclock,
# such as machine hardware clock type for Alphas.
CLOCKPARAMS=

# End /etc/sysconfig/clock
EOF

locale -a

# (1) prompt user, and read command line argument
read -p "Enter Preferred Locale: " answer
$pref_locale = $answer;


LC_ALL=$pref_locale locale charmap
LC_ALL=$pref_locale locale language
LC_ALL=$pref_locale locale charmap
LC_ALL=$pref_locale locale int_curr_symbol
LC_ALL=$pref_locale locale int_prefix

cat > /etc/profile << "EOF"
# Begin /etc/profile
export LANG=en_US.utf8
# End /etc/profile
EOF

cat > /etc/inputrc << "EOF"
cat > /etc/inputrc << "EOF"
# Begin /etc/inputrc
# Modified by Chris Lynn <roryo@roryo.dynup.net>
# Allow the command prompt to wrap to the next line
set horizontal-scroll-mode Off
# Enable 8bit input
set meta-flag On
set input-meta On
# Turns off 8th bit stripping
set convert-meta Off
# Keep the 8th bit for display
set output-meta On
# none, visible or audible
set bell-style none
# All of the following map the escape sequence of the value
# contained in the 1st argument to the readline specific functions
"\eOd": backward-word
"\eOc": forward-word
# for linux console
"\e[1~": beginning-of-line
"\e[4~": end-of-line
"\e[5~": beginning-of-history
"\e[6~": end-of-history
"\e[3~": delete-char
"\e[2~": quoted-insert
# for xterm
"\eOH": beginning-of-line
"\eOF": end-of-line
# for Konsole
"\e[H": beginning-of-line
"\e[F": end-of-line
# End /etc/inputrc
EOF

cat > /etc/shells << "EOF"
# Begin /etc/shells
/bin/sh
/bin/bash
# End /etc/shells
EOF

cat > /etc/fstab << "EOF"
# Begin /etc/fstab
# file system   mount-point type    options             dump fsck
# order
/dev/sda1       /           ext4    defaults            1   1
/dev/sda2       swap        swap    pri=1               0   0
proc            /proc       proc    nosuid,noexec,nodev 0   0
sysfs           /sys        sysfs   nosuid,noexec,nodev 0   0
devpts          /dev/pts    devpts  gid=5,mode=620      0   0
tmpfs           /run        tmpfs   defaults            0   0
devtmpfs        /dev        devtmpfs mode=0755,nosuid   0   0
# End /etc/fstab
EOF

# Linux-5.2.8 || Contains the Linux kernel || 4.4 - 66.0 SBUs
cd /sources
tar xvf linux-5.2.8.tar.xz
cd linux-5.2.8
make mrproper
read -p "Press [Enter] key to resume..."
make defconfig
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make modules_install
read -p "Press [Enter] key to resume..."
cp -iv arch/x86/boot/bzImage /boot/vmlinuz-5.2.8-lfs-9.0
cp -iv System.map /boot/System.map-5.2.8
cp -iv .config /boot/config-5.2.8
install -d /usr/share/doc/linux-5.2.8
cp -r Documentation/* /usr/share/doc/linux-5.2.8
install -v -m755 -d /etc/modprobe.d
cat > /etc/modprobe.d/usb.conf << "EOF"
# Begin /etc/modprobe.d/usb.conf
install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true
# End /etc/modprobe.d/usb.conf
EOF
cd /sources

# Currently broken on account of xorriso not included in LFS
#cd /tmp
#grub-mkrescue --output=grub-img.iso
#xorriso -as cdrecord -v dev=/dev/cdrw blank=as_needed grub-img.iso
grub-install /dev/sda

cat > /boot/grub/grub.cfg << "EOF"
# Begin /boot/grub/grub.cfg
set default=0
set timeout=5
insmod ext2
set root=(hd0,2)
menuentry "GNU/Linux, Linux 5.2.8-lfs-9.0" {
 linux /boot/vmlinuz-5.2.8-lfs-9.0 root=/dev/sda1 ro
}
EOF

echo 9.0 > /etc/lfs-release

cat > /etc/lsb-release << "EOF"
DISTRIB_ID="Linux From Scratch"
DISTRIB_RELEASE="9.0"
DISTRIB_CODENAME="LFS"
DISTRIB_DESCRIPTION="Linux From Scratch"
EOF

logout
exit
