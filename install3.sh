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

# Readline-8.0 || A set of libraries that offers command-line editing and history capabilitiese || 0.1 SBUs
tar xvf readline-8.0.tar.gz
cd readline-8.0
sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install
./configure --prefix=/usr \
--disable-static \
--docdir=/usr/share/doc/readline-8.0
read -p "Press [Enter] key to resume..."
make SHLIB_LIBS="-L/tools/lib -lncursesw"
read -p "Press [Enter] key to resume..."
make SHLIB_LIBS="-L/tools/lib -lncursesw" install
read -p "Press [Enter] key to resume..."
mv -v /usr/lib/lib{readline,history}.so.* /lib
chmod -v u+w /lib/lib{readline,history}.so.*
ln -sfv ../../lib/$(readlink /usr/lib/libreadline.so) /usr/lib/libreadline.so
ln -sfv ../../lib/$(readlink /usr/lib/libhistory.so ) /usr/lib/libhistory.so
install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-8.0
read -p "Press [Enter] key to resume..."
cd /mnt/lfs/sources
rm -Rf readline-8.0

# M4-1.4.18 || Copies the given files while expanding the macros that they contain || 0.4 SBUs
tar xvf m4-1.4.18.tar.xz
cd m4-1.4.18
sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' lib/*.c
echo "#define _IO_IN_BACKUP 0x100" >> lib/stdio-impl.h
./configure --prefix=/usr 
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make check
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /mnt/lfs/sources
rm -Rf m4-1.4.18
