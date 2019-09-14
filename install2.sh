#!/bin/bash  
#=================================================================================== 
# 
# Installs Basic System Software for Linux From Scratch 9.0 on a Red Hat based distribution of linux, such as Fedora, CentOS, or RHEL. 
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

shdir=`pwd`

touch /var/log/{btmp,lastlog,faillog,wtmp}
chgrp -v utmp /var/log/lastlog
chmod -v 664 /var/log/lastlog
chmod -v 600 /var/log/btmp
read -p "Press [Enter] key to resume..."

cd /sources
# Linux-5.2.8 || Linux API Headers expose the kernel's API for use by Glibc || less than 0.1 SBUs
tar xvf linux-5.2.8.tar.xz
cd linux-5.2.8
make mrproper
read -p "Press [Enter] key to resume..."
make INSTALL_HDR_PATH=dest headers_install
read -p "Press [Enter] key to resume..."
find dest/include \( -name .install -o -name ..install.cmd \) -delete
cp -rv dest/include/* /usr/include
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf linux-5.2.8


# Man-pages-5.02 || contains over 2,200 man pages || less than 0.1 SBUs
tar xvf man-pages-5.02.tar.xz
cd man-pages-5.02
make install
cd /sources
rm -Rf man-pages-5.02

# Glibc-2.30 || contains main C library || 21 SBUs
tar xvf glibc-2.30.tar.xz
cd glibc-2.30
patch -Np1 -i ../glibc-2.30-fhs-1.patch
sed -i '/asm.socket.h/a# include <linux/sockios.h>' \
   sysdeps/unix/sysv/linux/bits/socket.h
case $(uname -m) in
    i?86)   ln -sfv ld-linux.so.2 /lib/ld-lsb.so.3
    ;;
    x86_64) ln -sfv ../lib/ld-linux-x86-64.so.2 /lib64
            ln -sfv ../lib/ld-linux-x86-64.so.2 /lib64/ld-lsb-x86-64.so.3
    ;;
esac
read -p "Press [Enter] key to resume..."
mkdir -v build
cd build
CC="gcc -ffile-prefix-map=/tools=/usr" \
../configure --prefix=/usr                          \
             --disable-werror                       \
             --enable-kernel=3.2                    \
             --enable-stack-protector=strong        \
             --with-headers=/usr/include            \
             libc_cv_slibdir=/lib
read -p "Press [Enter] key to resume..."
make -j4
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
mkdir -pv /usr/lib/locale
localedef -i POSIX -f UTF-8 C.UTF-8 2> /dev/null || true
localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8
localedef -i de_DE -f ISO-8859-1 de_DE
localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro
localedef -i de_DE -f UTF-8 de_DE.UTF-8
localedef -i el_GR -f ISO-8859-7 el_GR
localedef -i en_GB -f UTF-8 en_GB.UTF-8
localedef -i en_HK -f ISO-8859-1 en_HK
localedef -i en_PH -f ISO-8859-1 en_PH
localedef -i en_US -f ISO-8859-1 en_US
localedef -i en_US -f UTF-8 en_US.UTF-8
localedef -i es_MX -f ISO-8859-1 es_MX
localedef -i fa_IR -f UTF-8 fa_IR
localedef -i fr_FR -f ISO-8859-1 fr_FR
localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro
localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
localedef -i it_IT -f ISO-8859-1 it_IT
localedef -i it_IT -f UTF-8 it_IT.UTF-8
localedef -i ja_JP -f EUC-JP ja_JP
localedef -i ja_JP -f SHIFT_JIS ja_JP.SIJS 2> /dev/null || true
localedef -i ja_JP -f UTF-8 ja_JP.UTF-8
localedef -i ru_RU -f KOI8-R ru_RU.KOI8-R
localedef -i ru_RU -f UTF-8 ru_RU.UTF-8
localedef -i tr_TR -f UTF-8 tr_TR.UTF-8
localedef -i zh_CN -f GB18030 zh_CN.GB18030
localedef -i zh_HK -f BIG5-HKSCS zh_HK.BIG5-HKSCS
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
tar -xf ../../tzdata2019b.tar.gz

ZONEINFO=/usr/share/zoneinfo
mkdir -pv $ZONEINFO/{posix,right}

for tz in etcetera southamerica northamerica europe africa antarctica  \
          asia australasia backward pacificnew systemv; do
    zic -L /dev/null   -d $ZONEINFO       ${tz}
    zic -L /dev/null   -d $ZONEINFO/posix ${tz}
    zic -L leapseconds -d $ZONEINFO/right ${tz}
done

cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
zic -d $ZONEINFO -p America/New_York
unset ZONEINFO
read -p "Press [Enter] key to resume..."
CTIME=$(tzselect)
echo "Your local time zone was detected to be"
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
cd /sources
rm -Rf glibc-2.30

# Adjusting the Toolchain
mv -v /tools/bin/{ld,ld-old}
mv -v /tools/$(uname -m)-pc-linux-gnu/bin/{ld,ld-old}
mv -v /tools/bin/{ld-new,ld}
ln -sv /tools/bin/ld /tools/$(uname -m)-pc-linux-gnu/bin/ld
gcc -dumpspecs | sed -e 's@/tools@@g'                   \
    -e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
    -e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' >      \
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
cd /sources
rm -Rf zlib-1.2.11

# File-5.37 || Tries to classify each given file || 0.1 SBUs
tar xvf file-5.37.tar.gz
cd file-5.37
./configure --prefix=/usr
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make check
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf file-5.37


read -p "Press [Enter] key to resume..."
cd $shdir

bash install3.sh
