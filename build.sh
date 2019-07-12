#!/bin/bash  
#=================================================================================== 
# 
# Builds necessary packages for Linux From Scratch 8.4 on a Red Hat based distribution of linux, such as Fedora, CentOS, or RHEL. 
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

# Enter previous password set
whoami 
cat > ~/.bash_profile << 'EOF' 
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash 
EOF

cat > ~/.bashrc << 'EOF' 
set +h 
umask 022 
LFS=/mnt/lfs 
LC_ALL=POSIX 
LFS_TGT=$(uname -m)-lfs-linux-gnu 
PATH=/tools/bin:/bin:/usr/bin 
export LFS LC_ALL LFS_TGT PATH 
EOF

cd ~/
source .bash_profile
cd /mnt/lfs/sources
if [$LFS != /mnt/lfs]
then
  export LFS=/mnt/lfs
read -p "Press [Enter] key to resume..."
tar xvf binutils-2.32.tar.xz
cd binutils-2.32
./config.guess
read -p "Press [Enter] key to resume..."
mkdir -v build; cd build
../configure --prefix=/tools --with-sysroot=$LFS --with-lib-path=/tools/lib --target=$LFS_TGT --disable-nls --disable-werror
case $(uname -m) in
  x86_64) mkdir -v /tools/lib && ln -sv lib /tools/lib64 ;;
esac
time make -j4
read -p "Press [Enter] key to resume..."
# real is 1 SBU
make install
read -p "Press [Enter] key to resume..."
cd ..
rm -Rf build
cd /mnt/lfs/sources
# Install Gcc
tar xvf gcc-8.2.0.tar.xz
cd gcc-8.2.0

# tar -xf ../mpfr-4.0.2.tar.xz
# mv -v mpfr-4.0.2 mpfr
# tar -xf ../gmp-6.1.2.tar.xz
# mv -v gmp-6.1.2 gmp
# tar -xf ../mpc-1.1.0.tar.gz
# mv -v mpc-1.1.0 mpc

./contrib/download_prerequisites
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
cd ..
mkdir objdir
cd objdir
$PWD/../gcc-8.2.0/configure \
 --target=$LFS_TGT \
 --prefix=/tools \
 --with-glibc-version=2.11 \
 --with-sysroot=$LFS \
 --with-newlib \
 --without-headers \
 --with-local-prefix=/tools \
 --with-native-system-header-dir=/tools/include \
 --disable-nls \
 --disable-shared \
 --disable-multilib \
 --disable-decimal-float \
 --disable-threads \
 --disable-libatomic \
 --disable-libgomp \
 --disable-libmpx \
 --disable-libquadmath \
 --disable-libssp \
 --disable-libvtv \
 --disable-libstdcxx \
 --enable-languages=c,c++
read -p "Press [Enter] key to resume..."
make -j4
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
break
echo 'Break failed'
exit
cd ..
pwd
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