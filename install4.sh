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

# Bzip2-1.0.6 || Contains programs for compressing and decompressing files|| 0.1 SBUs
tar xvf bzip2-1.0.6.tar.gz
cd bzip2-1.0.6
patch -Np1 -i ../bzip2-1.0.6-install_docs-1.patch
sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile
make -f Makefile-libbz2_so
make clean
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make PREFIX=/usr install
cp -v bzip2-shared /bin/bzip2
cp -av libbz2.so* /lib
ln -sv ../../lib/libbz2.so.1.0 /usr/lib/libbz2.so
rm -v /usr/bin/{bunzip2,bzcat,bzip2}
ln -sv bzip2 /bin/bunzip2
ln -sv bzip2 /bin/bzcat
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf bzip2-1.0.6

# Pkg-config-0.29.2 || Returns meta information for the specified library or package || 0.3 SBUs
tar xvf pkg-config-0.29.2.tar.gz
cd pkg-config-0.29.2
./configure --prefix=/usr \
--with-internal-glib \
--disable-host-tool \
--docdir=/usr/share/doc/pkg-config-0.29.2
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make check
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf pkg-config-0.29.2

# Ncurses-6.1 || Contains libraries for terminal-independent handling of character screens || 0.3 SBUs
tar xvf ncurses-6.1.tar.gz
cd ncurses-6.1
sed -i '/LIBTOOL_INSTALL/d' c++/Makefile.in
./configure --prefix=/usr \
--mandir=/usr/share/man \
--with-shared \
--without-debug \
--without-normal \
--enable-pc-files \
--enable-widec
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
mv -v /usr/lib/libncursesw.so.6* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libncursesw.so) /usr/lib/libncursesw.so
for lib in ncurses form panel menu ; do
rm -vf /usr/lib/lib${lib}.so
echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so
ln -sfv ${lib}w.pc /usr/lib/pkgconfig/${lib}.pc
done
rm -vf /usr/lib/libcursesw.so
echo "INPUT(-lncursesw)" > /usr/lib/libcursesw.so
ln -sfv libncurses.so /usr/lib/libcurses.so
mkdir -v /usr/share/doc/ncurses-6.1
cp -v -R doc/* /usr/share/doc/ncurses-6.1
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf ncurses-6.1

# Attr-2.4.48 || Extends attributes on filesystem objects || 0.3 SBUs
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

# Libcap-2.26 || Contains the library functions for manipulating POSIX 1003.1e capabilities || 0.1 SBUs
tar xvf libcap-2.26.tar.xz
cd libcap-2.26
sed -i '/install.*STALIBNAME/d' libcap/Makefile
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make RAISE_SETFCAP=no lib=lib prefix=/usr install
chmod -v 755 /usr/lib/libcap.so.2.26
read -p "Press [Enter] key to resume..."
mv -v /usr/lib/libcap.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libcap.so) /usr/lib/libcap.so
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf libcap-2.26

# Sed-4.7 || Filters and transforms text files in a single pass || 0.3 SBUs
tar xvf sed-4.7.tar.xz
cd sed-4.7
sed -i 's/usr/tools/' build-aux/help2man
sed -i 's/testsuite.panic-tests.sh//' Makefile.in
./configure --prefix=/usr --bindir=/bin
read -p "Press [Enter] key to resume..."
make
make html
read -p "Press [Enter] key to resume..."
make check
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
install -d -m755 /usr/share/doc/sed-4.7
install -m644 doc/sed.html /usr/share/doc/sed-4.7
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf sed-4.7

# Iana-etc-2.30 || Provides data for network services and protocol || 0.1 SBUs
tar xvf iana-etc-2.30.tar.bz2
cd iana-etc-2.30
make
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf iana-etc-2.30

# Bison-3.3.2 || Contains a parser generator || 0.3 SBUs
tar xvf bison-3.3.2.tar.xz
cd bison-3.3.2
./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.3.2
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf bison-3.3.2

# flex-2.6.4 || A tool for generating programs that recognize patterns in text || 0.4 SBUs
tar xvf flex-2.6.4.tar.gz
cd flex-2.6.4
sed -i "/math.h/a #include <malloc.h>" src/flexdef.h
HELP2MAN=/tools/bin/true \
./configure --prefix=/usr --docdir=/usr/share/doc/flex-2.6.4
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make check
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
ln -sv flex /usr/bin/lex
cd /sources
rm -Rf flex-2.6.4

# Grep-3.3 || Contains programs for searching through files || 0.4 SBUs
tar xvf grep-3.3.tar.xz
cd grep-3.3
./configure --prefix=/usr --bindir=/bin
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make -k check
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf grep-3.3

# bash-5.0 || A widely-used command interpreter || 1.7 SBUs
tar xvf bash-5.0.tar.gz
cd bash-5.0
./configure --prefix=/usr \
--docdir=/usr/share/doc/bash-5.0 \
--without-bash-malloc \
--with-installed-readline
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
chown -Rv nobody .
su nobody -s /bin/bash -c "PATH=$PATH HOME=/home make tests"
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
mv -vf /usr/bin/bash /bin
exec /bin/bash --login +h
read -p "Press [Enter] key to resume..."
