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

