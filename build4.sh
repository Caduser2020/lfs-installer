#!/bin/bash  
#=================================================================================== 
# 
# Builds text suite for Linux From Scratch 8.4 on a Red Hat based distribution of linux, such as Fedora, CentOS, or RHEL. 
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

cd mnt/lfs/sources
# Tcl-8.6.9 || Contains the Tool Command Language || 0.9 SBUs
# NOTE: 
tar xvf tcl8.6.9-src.tar.gz
cd tcl8.6.9
cd unix
./configure --prefix=/tools
read -p "Press [Enter] key to resume..."
make -j4
read -p "Press [Enter] key to resume..."
# As this test may fail under certain host conditions, this test may be removed in a feature version of LFS-installer.
# TZ=UTC make test
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
chmod -v u+w /tools/lib/libtcl8.6.so
make install-private-headers
ln -sv tclsh8.6 /tools/bin/tclsh
read -p "Press [Enter] key to resume..."
cd /mnt/lfs/sources
rm -Rf tcl8.6.9

# Expect5.45.4 || Contains a program for carrying out scripted dialogues with other interactive programs || 0.1 SBUs
tar xvf expect5.45.4.tar.gz
cd expect5.45.4
cp -v configure{,.orig}
sed 's:/usr/local/bin:/bin:' configure.orig > configure
read -p "Press [Enter] key to resume..."

./configure --prefix=/tools \
--with-tcl=/tools/lib \
--with-tclinclude=/tools/include
read -p "Press [Enter] key to resume..."

make -j4
read -p "Press [Enter] key to resume..."
make test
read -p "Press [Enter] key to resume..."
make SCRIPTS="" install
read -p "Press [Enter] key to resume..."
cd /mnt/lfs/sources
rm -Rf expect5.45.4

# Dejagnu-1.6.2 || Contains a framework for testing other programs || less than 0.1 SBUs
tar xvf dejagnu-1.6.2.tar.gz

./configure --prefix=/tools
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
# Test results
make check
read -p "Press [Enter] key to resume..."
cd /mnt/lfs/sources
rm -Rf dejagnu-1.6.2

bash build5.sh