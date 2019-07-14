
#!/bin/bash  
#=================================================================================== 
# 
# Builds second part of first toolchain pass for Linux From Scratch 8.4 on a Red Hat based distribution of linux, such as Fedora, CentOS, or RHEL. 
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

cd ..
if [ $LFS != /mnt/lfs ]
then
    export LFS=/mnt/lfs
else
    echo '\$LFS is set to /mnt/lfs'
fi
if [ -z "$shdir" ]; then echo "\$shdir is blank"; else echo "\$shdir is set to `$shdir`"; fi
echo 'PATH is `pwd`'
read -p "Press [Enter] key to resume..."
rm -Rf objdir
cd /mnt/lfs/sources
tar xvf linux-4.20.12.tar.xz
cd linux-4.20.12
make mrproper
read -p "Press [Enter] key to resume..."
make INSTALL_HDR_PATH=dest headers_install
read -p "Press [Enter] key to resume..."
cp -rv dest/include/* /tools/include
cd ..
cd /mnt/lfs/sources
tar xvf glibc-2.29.tar.xz
cd glibc-2.29
mkdir -v build
cd build
../configure \
 --prefix=/tools \
 --host=$LFS_TGT \
 --build=$(../scripts/config.guess) \
 --enable-kernel=3.2 \
 --with-headers=/tools/include
 read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
echo 'int main(){}' > dummy.c
$LFS_TGT-gcc dummy.c
readelf -l a.out | grep ': /tools'
# should say '[Requesting program interpreter: /tools/lib64/ld-linux-x86-64.so.2]'
rm -v dummy.c a.out