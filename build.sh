#!/bin/bash
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
# . ~/.bash_profile
cd /mnt/lfs/sources
tar xvf binutils-2.32.tar.xz
cd binutils-2.32
 mkdir -v build; cd build
../configure --prefix=/tools --with-sysroot=$LFS --with-lib-path=/tools/lib --target=$LFS_TGT --disable-nls --disable-werror
time make -j2
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
make -j4
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
break
echo 'Break failed'
exit
# cd ..
# pwd
# rm -Rf objdir
# cd /mnt/lfs/sources
# tar xvf linux-4.20.12.tar.xz
# cd linux-4.20.12
# make mrproper
# make INSTALL_HDR_PATH=dest headers_install
# cp -rv dest/include/* /tools/include
# cd ..
# cd /mnt/lfs/sources
# tar xvf glibc-2.29.tar.xz
# cd glibc-2.29
# mkdir -v build
# cd build
# ../configure \
#  --prefix=/tools \
#  --host=$LFS_TGT \
#  --build=$(../scripts/config.guess) \
#  --enable-kernel=3.2 \
#  --with-headers=/tools/include
# make
# make install
# echo 'int main(){}' > dummy.c
# $LFS_TGT-gcc dummy.c
# readelf -l a.out | grep ': /tools'
# should say '[Requesting program interpreter: /tools/lib64/ld-linux-x86-64.so.2]'
# rm -v dummy.c a.out
