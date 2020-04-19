#!/bin/bash  
#=================================================================================== 
# 
# Builds second part of first toolchain pass for Linux From Scratch 9.1 on a Red Hat based distribution of linux, such as Fedora, CentOS, or RHEL. 
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
#===================================================================================

# cd ..
if [ $LFS != /mnt/lfs ]
then
    export LFS=/mnt/lfs
else
    echo '\$LFS is set to /mnt/lfs'
fi
if [ -z "$shdir" ]; then echo "\$shdir is blank"; else echo "\$shdir is set to `$shdir`"; fi
echo 'PATH is `pwd`'
read -p "Press [Enter] key to resume..."
cd /mnt/lfs/sources

# Linux-5.5.3 || Linux API Headers expose the kernel's API for use by Glibc || less than 0.1 SBUs
tar xvf linux-5.5.3.tar.xz
cd linux-5.5.3
make mrproper
read -p "Press [Enter] key to resume..."
make headers
cp -rv usr/include/* /tools/include
read -p "Press [Enter] key to resume..."
cd ..
rm -Rf linux-5.5.3
cd /mnt/lfs/sources

# Glibc-2.31 || contains main C library || 4.8 SBUs
tar xvf glibc-2.31.tar.xz
cd glibc-2.31
mkdir -v build
cd build
../configure \
 --prefix=/tools \
 --host=$LFS_TGT \
 --build=$(../scripts/config.guess) \
 --enable-kernel=3.2 \
 --with-headers=/tools/include
read -p "Press [Enter] key to resume..."
make -j1
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd ..
echo 'int main(){}' > dummy.c
$LFS_TGT-gcc dummy.c
readelf -l a.out | grep ': /tools'
read -p "should say '[Requesting program interpreter: /tools/lib64/ld-linux-x86-64.so.2]'"
rm -v dummy.c a.out
rm -Rf glibc-2.31

# Libstdc++ from GCC-9.2.0 || Contains standard C++ library || 0.5 SBUs
# Unpack the gcc tarball again
tar xvf gcc-9.2.0.tar.xz
cd gcc-9.2.0
mkdir -v build
cd build
../libstdc++-v3/configure \
    --host=$LFS_TGT \
    --prefix=/tools \
    --disable-multilib \
    --disable-nls \
    --disable-libstdcxx-threads \
    --disable-libstdcxx-pch \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/9.2.0
read -p "Press [Enter] key to resume..."
make -j${cpus}
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /mnt/lfs/sources
rm -Rf gcc-9.2.0
bash $shdir/build3.sh