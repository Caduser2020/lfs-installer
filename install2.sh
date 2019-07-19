#!/bin/bash  
#=================================================================================== 
# 
# Installs Basic System Software for Linux From Scratch 8.4 on a Red Hat based distribution of linux, such as Fedora, CentOS, or RHEL. 
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

cd /mnt/lfs/sources
if [ $LFS != /mnt/lfs ]
then
    export LFS=/mnt/lfs
else
    echo '\$LFS is set to /mnt/lfs'
fi
if [ -z "$shdir" ]; then echo "\$shdir is blank"; else echo "\$shdir is set to `$shdir`"; fi
echo 'PATH is `pwd`'
read -p "Press [Enter] key to resume..."

chown -R root:root $LFS/tools
mknod -m 600 $LFS/dev/console c 5 1
mknod -m 666 $LFS/dev/null c 1 3
mount -v --bind /dev $LFS/dev
mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run
if [ -h $LFS/dev/shm ]; then
mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi

read -p "Press [Enter] key to resume..."
chroot "$LFS" /tools/bin/env -i \
HOME=/root \
TERM="$TERM" \
PS1='(lfs chroot) \u:\w\$ ' \
PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
/tools/bin/bash --login +h
read -p "Press [Enter] key to resume..."

mkdir -pv /{bin,boot,etc/{opt,sysconfig},home,lib/firmware,mnt,opt}
mkdir -pv /{media/{floppy,cdrom},sbin,srv,var}
install -dv -m 0750 /root
install -dv -m 1777 /tmp /var/tmp
mkdir -pv /usr/{,local/}{bin,include,lib,sbin,src}
mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man}
mkdir -v /usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -v /usr/libexec
mkdir -pv /usr/{,local/}share/man/man{1..8}
case $(uname -m) in
x86_64) mkdir -v /lib64 ;;
esac
mkdir -v /var/{log,mail,spool}
ln -sv /run /var/run
ln -sv /run/lock /var/lock
mkdir -pv /var/{opt,cache,lib/{color,misc,locate},local}
read -p "Press [Enter] key to resume..."

ln -sv /tools/bin/{bash,cat,chmod,dd,echo,ln,mkdir,pwd,rm,stty,touch} /bin
ln -sv /tools/bin/{env,install,perl,printf} /usr/bin
ln -sv /tools/lib/libgcc_s.so{,.1} /usr/lib
ln -sv /tools/lib/libstdc++.{a,so{,.6}} /usr/lib
install -vdm755 /usr/lib/pkgconfig
ln -sv bash /bin/sh
read -p "Press [Enter] key to resume..."

ln -sv /proc/self/mounts /etc/mtab
cat > /etc/passwd << "EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/bin/false
daemon:x:6:6:Daemon User:/dev/null:/bin/false
messagebus:x:18:18:D-Bus Message Daemon User:/var/run/dbus:/bin/false
nobody:x:99:99:Unprivileged User:/dev/null:/bin/false
EOF
read -p "Press [Enter] key to resume..."

cat > /etc/group << "EOF"
root:x:0:
bin:x:1:daemon
sys:x:2:
kmem:x:3:
tape:x:4:
tty:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
usb:x:14:
cdrom:x:15:
adm:x:16:
messagebus:x:18:
input:x:24:
mail:x:34:
kvm:x:61:
wheel:x:97:
nogroup:x:99:
users:x:999:
EOF
read -p "Press [Enter] key to resume..."

exec /tools/bin/bash --login +h
touch /var/log/{btmp,lastlog,faillog,wtmp}
chgrp -v utmp /var/log/lastlog
chmod -v 664 /var/log/lastlog
chmod -v 600 /var/log/btmp
read -p "Press [Enter] key to resume..."

cd /mnt/lfs/sources
# Linux-4.20.12 || Linux API Headers expose the kernel's API for use by Glibc || less than 0.1 SBUs
tar xvf linux-4.20.12.tar.xz
cd linux-3.8.1
make mrproper
read -p "Press [Enter] key to resume..."
make INSTALL_HDR_PATH=dest headers_install
read -p "Press [Enter] key to resume..."
find dest/include \( -name .install -o -name ..install.cmd \) -delete
cp -rv dest/include/* /usr/include
read -p "Press [Enter] key to resume..."
cd /mnt/lfs/sources
rm -Rf linux-4.20.12


# Man-pages-4.16 || contains over 2,200 man pages || less than 0.1 SBUs
tar xvf man-pages-4.16.tar.xz
cd man-pages-4.16
make install
read -p "Press [Enter] key to resume..."
cd /mnt/lfs/sources
rm -Rf man-pages-4.16

# Glibc-2.29 || contains main C library || 22 SBUs(lol)
tar xvf glibc-2.29.tar.xz
cd glibc-2.29
patch -Np1 -i ../glibc-2.29-fhs-1.patch
ln -sfv /tools/lib/gcc /usr/lib
case $(uname -m) in
i?86) GCC_INCDIR=/usr/lib/gcc/$(uname -m)-pc-linux-gnu/8.2.0/include
ln -sfv ld-linux.so.2 /lib/ld-lsb.so.3
;;
x86_64) GCC_INCDIR=/usr/lib/gcc/x86_64-pc-linux-gnu/8.2.0/include
ln -sfv ../lib/ld-linux-x86-64.so.2 /lib64
ln -sfv ../lib/ld-linux-x86-64.so.2 /lib64/ld-lsb-x86-64.so.3
;;
esac
read -p "Press [Enter] key to resume..."

rm -f /usr/include/limits.h
mkdir -v build
cd build
CC="gcc -isystem $GCC_INCDIR -isystem /usr/include" \
../configure --prefix=/usr \
--disable-werror \
--enable-kernel=3.2 \
--enable-stack-protector=strong \
libc_cv_slibdir=/lib
unset GCC_INCDIR
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
case $(uname -m) in
i?86) ln -sfnv $PWD/elf/ld-linux.so.2 /lib ;;
x86_64) ln -sfnv $PWD/elf/ld-linux-x86-64.so.2 /lib ;;
esac
make check
read -p "Press [Enter] key to resume..."

touch /etc/ld.so.conf
sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile
make install
read -p "Press [Enter] key to resume..."
cp -v ../nscd/nscd.conf /etc/nscd.conf
mkdir -pv /var/cache/nscd
make localedata/install-locales
read -p "Press [Enter] key to resume..."
cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf
passwd: files
group: files
shadow: files
hosts: files dns
networks: files
protocols: files
services: files
ethers: files
rpc: files
# End /etc/nsswitch.conf
EOF
tar -xf ../../tzdata2018i.tar.gz
ZONEINFO=/usr/share/zoneinfo
mkdir -pv $ZONEINFO/{posix,right}
for tz in etcetera southamerica northamerica europe africa antarctica \
asia australasia backward pacificnew systemv; do
zic -L /dev/null -d $ZONEINFO ${tz}
zic -L /dev/null -d $ZONEINFO/posix ${tz}
zic -L leapseconds -d $ZONEINFO/right ${tz}
done
cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
zic -d $ZONEINFO -p America/New_York
unset ZONEINFO
read -p "Press [Enter] key to resume..."
CTIME=$(tzselect)
echo $CTIME
read -p "Press [Enter] key to resume..."
cp -v /usr/share/zoneinfo/$CTIME /etc/localtime
cat > /etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf
/usr/local/lib
/opt/lib
EOF
cat >> /etc/ld.so.conf << "EOF"
# Add an include directory
include /etc/ld.so.conf.d/*.conf
EOF
mkdir -pv /etc/ld.so.conf.d
cd /mnt/lfs/sources
rm -Rf glibc-2.29

# Adjusting the Toolchain
mv -v /tools/bin/{ld,ld-old}
mv -v /tools/$(uname -m)-pc-linux-gnu/bin/{ld,ld-old}
mv -v /tools/bin/{ld-new,ld}
ln -sv /tools/bin/ld /tools/$(uname -m)-pc-linux-gnu/bin/ld
gcc -dumpspecs | sed -e 's@/tools@@g' \
-e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
-e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' > \
`dirname $(gcc --print-libgcc-file-name)`/specs
read -p "Press [Enter] key to resume..."
echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'
read -p "Press [Enter] key to resume..."
grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log
read -p "Press [Enter] key to resume..."
grep -B1 '^ /usr/include' dummy.log
read -p "Press [Enter] key to resume..."
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
read -p "Press [Enter] key to resume..."
grep "/lib.*/libc.so.6 " dummy.log
read -p "Press [Enter] key to resume..."
grep found dummy.log
read -p "Press [Enter] key to resume..."
rm -v dummy.c a.out dummy.log

# Zlib-1.2.11 || Contains compression and decompression functions used by some programs || less than 0.1 SBUs
tar xvf zlib-1.2.11.tar.xz
cd zlib-1.2.11
./configure --prefix=/usr
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
mv -v /usr/lib/libz.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libz.so) /usr/lib/libz.so
cd /mnt/lfs/sources
rm -Rf zlib-1.2.11

# File-5.36 || Tries to classify each given file || 0.1 SBUs
tar xvf file-5.36.tar.gz
cd file-5.36
./configure --prefix=/usr
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make check
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /mnt/lfs/sources
rm -Rf file-5.36

