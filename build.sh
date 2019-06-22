#!/bin/bash
# Enter previous password set
whoami 
cat > ~/.bash_profile << 'EOF' /
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash /
EOF

cat > ~/.bashrc << 'EOF' /
set +h /
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/tools/bin:/bin:/usr/bin
export LFS LC_ALL LFS_TGT PATH
EOF
source ~/.bash_profile
cd /mnt/lfs/sources
tar xvf binutils-2.32.tar.xz
cd binutils-2.32
 mkdir -v build; cd build
../configure --prefix=/tools --with-sysroot=$LFS --with-lib-path=/tools/lib --target=$LFS_TGT --disable-nls --disable-werror
time make -j2
# real is 1 SBU
make install
cd ..
rm -Rf build
tar xvf gcc-8.2.0.tar.xz
cd gcc-8.2.0
tar -xf ../mpfr-4.0.2.tar.xz
mv -v mpfr-4.0.2 mpfr
tar -xf ../gmp-6.1.2.tar.xz
mv -v gmp-6.1.2 gmp
tar -xf ../mpc-1.1.0.tar.gz
mv -v mpc-1.1.0 mpc
for file in gcc/config/{linux,i386/linux{,64}}.h \
do \
 cp -uv $file{,.orig} \
 sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
 -e 's@/usr@/tools@g' $file.orig > $file \
 echo ' \
#undef STANDARD_STARTFILE_PREFIX_1 \
#undef STANDARD_STARTFILE_PREFIX_2 \
#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/" \
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file \
 touch $file.orig \
done
mkdir -v build
cd build
../configure \
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
make -j2
make install
