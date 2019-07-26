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

cd /sources
if [ $LFS != /mnt/lfs ]
then
    export LFS=/mnt/lfs
else
    echo '\$LFS is set to /mnt/lfs'
fi
if [ -z "$shdir" ]; then echo "\$shdir is blank"; else echo "\$shdir is set to `$shdir`"; fi
echo 'PATH is `pwd`'
read -p "Press [Enter] key to resume..."


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
cd /sources
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
cd /sources
rm -Rf m4-1.4.18

# Bc-1.07.1 || A command line calculator & A reverse-polish command line calculator || 0.1 SBUs
tar xvf bc-1.07.1.tar.gz
cd bc-1.07.1
cat > bc/fix-libmath_h << "EOF"
#! /bin/bash
sed -e '1 s/^/{"/' \
-e 's/$/",/' \
-e '2,$ s/^/"/' \
-e '$ d' \
-i libmath.h
sed -e '$ s/$/0}/' \
-i libmath.h
EOF
ln -sv /tools/lib/libncursesw.so.6 /usr/lib/libncursesw.so.6
ln -sfv libncursesw.so.6 /usr/lib/libncurses.so
sed -i -e '/flex/s/as_fn_error/: ;; # &/' configure
./configure --prefix=/usr \
--with-readline \
--mandir=/usr/share/man \
--infodir=/usr/share/info
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
echo "quit" | ./bc/bc -l Test/checklib.b
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf bc-1.07.1

# Binutils-2.32 || Contains a linker, an assembler, and other tools for handling object files || 6.9 SBUs
tar xvf binutils-2.32.tar.xz
cd binutils-2.32
expect -c "spawn ls"
mkdir -v build
cd build
../configure --prefix=/usr \
--enable-gold \
--enable-ld=default \
--enable-plugins \
--enable-shared \
--disable-werror \
--enable-64-bit-bfd \
--with-system-zlib
read -p "Press [Enter] key to resume..."
make tooldir=/usr
read -p "Press [Enter] key to resume..."
make -k check
read -p "Press [Enter] key to resume..."
make tooldir=/usr install
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf binutils-2.32

# Gmp-6.1.2 || Contains precision math functions || 1.3 SBUs
tar xvf gmp-6.1.2.tar.xz
cd gmp-6.1.2
./configure --prefix=/usr \
--enable-cxx \
--disable-static \
--docdir=/usr/share/doc/gmp-6.1.2
read -p "Press [Enter] key to resume..."
make
make html
read -p "Press [Enter] key to resume..."
make check 2>&1 | tee gmp-check-log
awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log
read -p "Press [Enter] key to resume..."
make install
make install-html
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf gmp-6.1.2

# Mpfr-4.0.2 || Contains multiple-precision math functions || 1.0 SBUs
tar xvf mpfr-4.0.2.tar.xz
cd mpfr-4.0.2
./configure --prefix=/usr \
--disable-static \
--enable-thread-safe \
--docdir=/usr/share/doc/mpfr-4.0.2
read -p "Press [Enter] key to resume..."
make
make html
read -p "Press [Enter] key to resume..."
make check
read -p "Press [Enter] key to resume..."
make install
make install-html
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf mpfr-4.0.2

# Mpc-1.1.0 || Contains complex math functions || 0.3 SBUs
tar xvf mpc-1.1.0.tar.gz
cd mpc-1.1.0
./configure --prefix=/usr \
--disable-static \
--docdir=/usr/share/doc/mpc-1.1.0
read -p "Press [Enter] key to resume..."
make
make html
read -p "Press [Enter] key to resume..."
make check
read -p "Press [Enter] key to resume..."
make install
make install-html
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf mpc-1.1.0

# shadow-4.6 || Contains programs for handling passwords in a secure way || 0.2 SBUs
tar xvf shadow-4.6.tar.xz
cd shadow-4.6
sed -i 's/groups$(EXEEXT) //' src/Makefile.in
find man -name Makefile.in -exec sed -i 's/groups\.1 / /' {} \;
find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
find man -name Makefile.in -exec sed -i 's/passwd\.5 / /' {} \;
sed -i -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' \
-e 's@/var/spool/mail@/var/mail@' etc/login.defs
sed -i 's/1000/999/' etc/useradd
./configure --sysconfdir=/etc --with-group-name-max-length=32
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
mv -v /usr/bin/passwd /bin
cd /sources
rm -Rf shadow-4.6
pwconv
grpconv
passwd root

# Gcc-8.2.0 || Contains the GNU compiler collection || 92 SBUs || Basically just go to sleep
tar xvf gcc-8.2.0.tar.xz
cd gcc-8.2.0
case $(uname -m) in
x86_64)
sed -e '/m64=/s/lib64/lib/' \
-i.orig gcc/config/i386/t-linux64
;;
esac
rm -f /usr/lib/gcc
mkdir -v build
cd build
SED=sed \
../configure --prefix=/usr \
--enable-languages=c,c++ \
--disable-multilib \
--disable-bootstrap \
--disable-libmpx \
--with-system-zlib
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
ulimit -s 32768
rm ../gcc/testsuite/g++.dg/pr83239.C
chown -Rv nobody .
su nobody -s /bin/bash -c "PATH=$PATH make -k check"
../contrib/test_summary | grep -A7 Summ
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
ln -sv ../usr/bin/cpp /lib
ln -sv gcc /usr/bin/cc
install -v -dm755 /usr/lib/bfd-plugins
ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/8.2.0/liblto_plugin.so \
/usr/lib/bfd-plugins/
cd /sources
rm -Rf gcc-8.2.0
echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'
read -p "Press [Enter] key to resume..."
grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log
read -p "Press [Enter] key to resume..."
grep -B4 '^ /usr/include' dummy.log
read -p "Press [Enter] key to resume..."
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
read -p "Press [Enter] key to resume..."
grep "/lib.*/libc.so.6 " dummy.log
read -p "Press [Enter] key to resume..."
grep found dummy.log
read -p "Press [Enter] key to resume..."
rm -v dummy.c a.out dummy.log
mkdir -pv /usr/share/gdb/auto-load/usr/lib
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib
cd /sources
rm -Rf gcc-8.2.0

