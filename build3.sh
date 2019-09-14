#!/bin/bash  
#=================================================================================== 
# 
# Builds second toolchain pass for Linux From Scratch 8.4 on a Red Hat based distribution of linux, such as Fedora, CentOS, or RHEL. 
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
if [ -z "$shdir" ]; then echo "\$shdir is blank"; else echo "\$shdir is set to $shdir"; fi
echo 'PATH is `pwd`'
read -p "Press [Enter] key to resume..."

cd mnt/lfs/sources

# Binutils-2.32 - Pass 2|| Contains a linker, an assembler, and other tools for handling object files || 1.1 SBUs

tar xvf binutils-2.32.tar.xz
cd binutils-2.32
mkdir -v build
cd build
CC=$LFS_TGT-gcc \
AR=$LFS_TGT-ar \
RANLIB=$LFS_TGT-ranlib \
../configure \
    --prefix=/tools \
    --disable-nls \
    --disable-werror \
    --with-lib-path=/tools/lib \
    --with-sysroot
read -p "Press [Enter] key to resume..."
make -j4
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
make -C ld clean
read -p "Press [Enter] key to resume..."
make -C ld LIB_PATH=/usr/lib:/lib
cp -v ld/ld-new /tools/bin
cd /mnt/lfs/sources
rm -Rf binutils-2.32
read -p "Press [Enter] key to resume..."

# GCC-9.2.0 - Pass 2 || Contains the GNU compiler collection || 15 SBUs
tar xvf gcc-9.2.0.tar.xz
cd gcc-9.2.0

unset LIBRARY_PATH
LIBRARY_PATH=/usr/lib/x86_64-linux-gnu
export LIBRARY_PATH

cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
`dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include-fixed/limits.h
read -p "Press [Enter] key to resume..."
for file in gcc/config/{linux,i386/linux{,64}}.h
do
cp -uv $file{,.orig}
sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
-e 's@/usr@/tools@g' $file.orig > $file
echo '
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
touch $file.orig
done
case $(uname -m) in
x86_64)
sed -e '/m64=/s/lib64/lib/' \
-i.orig gcc/config/i386/t-linux64
;;
esac

./contrib/download_prerequisites
mkdir -v build; cd build

CC=$LFS_TGT-gcc \
CXX=$LFS_TGT-g++ \
AR=$LFS_TGT-ar \
RANLIB=$LFS_TGT-ranlib \
../configure \
--prefix=/tools \
--with-local-prefix=/tools \
--with-native-system-header-dir=/tools/include \
--enable-languages=c,c++ \
--disable-libstdcxx-pch \
--disable-multilib \
--disable-bootstrap \
--disable-libgomp
read -p "Press [Enter] key to resume..."
make -j4
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
ln -sv gcc /tools/bin/cc
read -p "Press [Enter] key to resume..."
cd /mnt/lfs/sources
rm -Rf gcc-9.2.0
echo 'int main(){}' > dummy.c
cc dummy.c
readelf -l a.out | grep ': /tools'
echo $PATH
rm -v dummy.c a.out

bash $shdir/build4.sh
