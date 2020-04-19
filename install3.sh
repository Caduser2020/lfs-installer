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

# Bc-2.5.3 || A command line calculator & A reverse-polish command line calculator || 0.1 SBUs
tar xvf bc-2.5.3.tar.gz
cd bc-2.5.3
PREFIX=/usr CC=gcc CFLAGS="-std=c99" ./configure.sh -G -O3
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make test
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf bc-2.5.3

# Binutils-2.34 || Contains a linker, an assembler, and other tools for handling object files || 6.7 SBUs
tar xvf binutils-2.34.tar.xz
cd binutils-2.34
expect -c "spawn ls"
sed -i '/@\tincremental_copy/d' gold/testsuite/Makefile.in
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
rm -Rf binutils-2.34

# Gmp-6.2.0 || Contains precision math functions || 1.1 SBUs
tar xvf gmp-6.2.0.tar.xz
cd gmp-6.2.0
./configure --prefix=/usr \
--enable-cxx \
--disable-static \
--docdir=/usr/share/doc/gmp-6.2.0
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
rm -Rf gmp-6.2.0

# Mpfr-4.0.2 || Contains multiple-precision math functions || 0.8 SBUs
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

# Attr-2.4.48 || Extends attributes on filesystem objects || less than 0.1 SBUs
tar xvf attr-2.4.48.tar.gz
cd attr-2.4.48
./configure --prefix=/usr \
--bindir=/bin \
--disable-static \
--sysconfdir=/etc \
--docdir=/usr/share/doc/attr-2.4.48
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make check
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
mv -v /usr/lib/libattr.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libattr.so) /usr/lib/libattr.so
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf attr-2.4.48

# Acl-2.2.53 || contains utilities to administer Access Control Lists || 0.1 SBUs
tar xvf acl-2.2.53.tar.gz
cd acl-2.2.53
./configure --prefix=/usr \
--bindir=/bin \
--disable-static \
--libexecdir=/usr/lib \
--docdir=/usr/share/doc/acl-2.2.53
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
mv -v /usr/lib/libacl.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libacl.so) /usr/lib/libacl.so
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf acl-2.2.53

# shadow-4.8.1 || Contains programs for handling passwords in a secure way || 0.2 SBUs
tar xvf shadow-4.8.1.tar.xz
cd shadow-4.8.1
sed -i 's/groups$(EXEEXT) //' src/Makefile.in
find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \;
find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;
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
rm -Rf shadow-4.8.1
pwconv
grpconv
passwd root

# Gcc-9.2.0 || Contains the GNU compiler collection || 88 SBUs
tar xvf gcc-9.2.0.tar.xz
cd gcc-9.2.0
case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
  ;;
esac
sed -e '1161 s|^|//|' \
-i libsanitizer/sanitizer_common/sanitizer_platform_limits_posix.cc
mkdir -v build
cd build
SED=sed                               \
../configure --prefix=/usr            \
             --enable-languages=c,c++ \
             --disable-multilib       \
             --disable-bootstrap      \
             --with-system-zlib
read -p "Press [Enter] key to resume..."
make
# Commented out because the tests take almost as long as the compile
# read -p "Press [Enter] key to resume..."
ulimit -s 32768
chown -Rv nobody .
su nobody -s /bin/bash -c "PATH=$PATH make -k check"
../contrib/test_summary | grep -A7 Summ
read -p "Press [Enter] key to resume..."
make install
rm -rf /usr/lib/gcc/$(gcc -dumpmachine)/9.2.0/include-fixed/bits/
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf gcc-9.2.0
chown -v -R root:root \
    /usr/lib/gcc/*linux-gnu/9.2.0/include{,-fixed}
ln -sv ../usr/bin/cpp /lib
ln -sv gcc /usr/bin/cc
install -v -dm755 /usr/lib/bfd-plugins
ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/9.2.0/liblto_plugin.so \
        /usr/lib/bfd-plugins/
echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'
echo "Output of last command should be: [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]"
read -p "Press [Enter] key to resume..."
grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log
echo "Output of last command should be: "
echo "/usr/lib/gcc/x86_64-pc-linux-gnu/9.2.0/../../../../lib/crt1.o succeeded"
echo "/usr/lib/gcc/x86_64-pc-linux-gnu/9.2.0/../../../../lib/crti.o succeeded"
echo "/usr/lib/gcc/x86_64-pc-linux-gnu/9.2.0/../../../../lib/crtn.o succeeded"
read -p "Press [Enter] key to resume..."
grep -B4 '^ /usr/include' dummy.log 
echo "Output of last command should be: "
echo "#include <...> search starts here:"
echo "/usr/lib/gcc/x86_64-pc-linux-gnu/9.2.0/include"
echo "/usr/local/include"
echo "/usr/lib/gcc/x86_64-pc-linux-gnu/9.2.0/include-fixed"
echo "/usr/include"
read -p "Press [Enter] key to resume..."
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
echo "References to paths that have components with '-linux-gnu' should \
be ignored, but otherwise the output of last command should be: "
echo 'SEARCH_DIR("/usr/x86_64-pc-linux-gnu/lib64")'
echo 'SEARCH_DIR("/usr/local/lib64")'
echo 'SEARCH_DIR("/lib64")'
echo 'SEARCH_DIR("/usr/lib64")'
echo 'SEARCH_DIR("/usr/x86_64-pc-linux-gnu/lib")'
echo 'SEARCH_DIR("/usr/local/lib")'
echo 'SEARCH_DIR("/lib")'
echo 'SEARCH_DIR("/usr/lib");'
read -p "Press [Enter] key to resume..."
grep "/lib.*/libc.so.6 " dummy.log
echo "Output of last command should be: "
echo "attempt to open /lib/libc.so.6 succeeded"
read -p "Press [Enter] key to resume..."
grep found dummy.log
echo "Output of last command should be: "
echo "found ld-linux-x86-64.so.2 at /lib/ld-linux-x86-64.so.2"
read -p "Press [Enter] key to resume..."
rm -v dummy.c a.out dummy.log
mkdir -pv /usr/share/gdb/auto-load/usr/lib
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib
cd /sources
rm -Rf gcc-9.2.0

bash $shdir/install4.sh
