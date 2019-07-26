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
cd /sources
rm -Rf bash-5.0

# Libtool-2.4.6 || Provides generalized library-building support services || 1.5 SBUs
tar xvf libtool-2.4.6.tar.xz
cd libtool-2.4.6
./configure --prefix=/usr 
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make check TESTSUITEFLAGS=-j4
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf libtool-2.4.6

# Gdbm-1.18.1 || Contains functions to manipulate a hashed database || 0.1 SBUs
tar xvf gdbm-1.18.1.tar.gz
cd gdbm-1.18.1
./configure --prefix=/usr \
--disable-static \
--enable-libgdbm-compat 
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make check
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf gdbm-1.18.1

# Gperf-3.1 || Generates a perfect hash from a key set || 0.1 SBUs
tar xvf gperf-3.1.tar.gz
cd gperf-3.1
./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.1
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make -j1 check
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf gperf-3.1

# Expat-2.2.6 || Contains API functions for parsing XML || 0.1 SBUs
tar xvf expat-2.2.6.tar.bz2
cd expat-2.2.6
sed -i 's|usr/bin/env |bin/|' run.sh.in
./configure --prefix=/usr \
--disable-static \
--docdir=/usr/share/doc/expat-2.2.6
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make -j1 check
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
install -v -m644 doc/*.{html,png,css} /usr/share/doc/expat-2.2.6
cd /sources
rm -Rf expat-2.2.6

# inetutils-1.9.4 || Contains programs for basic networking || 0.3 SBUs
tar xvf inetutils-1.9.4.tar.xz
cd inetutils-1.9.4
./configure --prefix=/usr \
--localstatedir=/var \
--disable-logger \
--disable-whois \
--disable-rcp \
--disable-rexec \
--disable-rlogin \
--disable-rsh \
--disable-servers
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make check
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
mv -v /usr/bin/{hostname,ping,ping6,traceroute} /bin
mv -v /usr/bin/ifconfig /sbin
cd /sources
rm -Rf inetutils-1.9.4

# Perl-5.28.1 || Contains the Practical Extraction and Report Language || 7.1 SBUs
tar xvf perl-5.28.1.tar.xz
cd perl-5.28.1
echo "127.0.0.1 localhost $(hostname)" > /etc/hosts
export BUILD_ZLIB=False
export BUILD_BZIP2=0
sh Configure -des -Dprefix=/usr \
-Dvendorprefix=/usr \
-Dman1dir=/usr/share/man/man1 \
-Dman3dir=/usr/share/man/man3 \
-Dpager="/usr/bin/less -isR" \
-Duseshrplib \
-Dusethreads
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
# WARNING VERY EXPENSIVE TEST || DO NOT RUN UNLESS YOU KNOW WHAT YOU ARE DOING
# make -k check
read -p "Press [Enter] key to resume..."
make install
unset BUILD_ZLIB BUILD_BZIP2
cd /sources
rm -Rf perl-5.28.1

# XML-Parser-2.44 || Provides the Perl Expat interface|| 0.1 SBUs
tar xvf XML-Parser-2.44.tar.gz
cd XML-Parser-2.44
perl Makefile.PL
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make test
read -p "Press [Enter] key to resume..."
make install
cd /sources
rm -Rf XML-Parser-2.44

# Intltool-0.51.0 || Internationalization tool used for extracting translatable strings from source files || 0.1 SBUs
tar xvf intltool-0.51.0.tar.gz
cd intltool-0.51.0
sed -i 's:\\\${:\\\$\\{:' intltool-update.in
./configure --prefix=/usr
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make check
read -p "Press [Enter] key to resume..."
make install
install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.51.0/I18N-HOWTO
cd /sources
rm -Rf intltool-0.51.0

# Autoconf-2.69 || Contains programs for producing shell scripts that can automatically configure source code || 0.1 SBUs
tar xvf autoconf-2.69.tar.xz
cd autoconf-2.69
sed '361 s/{/\\{/' -i bin/autoscan.in
./configure --prefix=/usr
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
# WARNING BROKEN TEST || DO NOT RUN UNLESS YOU KNOW WHAT YOU ARE DOING
# make check
read -p "Press [Enter] key to resume..."
make install
cd /sources
rm -Rf autoconf-2.69

# Automake-1.16.1 || A tool for automatically generating Makefile.in files from Makefile.am files || 0.1 SBUs
tar xvf automake-1.16.1.tar.xz
cd automake-1.16.1
./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.16.1
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make -j4 check
read -p "Press [Enter] key to resume..."
make install
cd /sources
rm -Rf automake-1.16.1

# Xz-5.2.4 || Contains programs for compressing and decompressing files || 0.2 SBUs
tar xvf xz-5.2.4.tar.xz
cd xz-5.2.4
./configure --prefix=/usr \
--disable-static \
--docdir=/usr/share/doc/xz-5.2.4
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make check
read -p "Press [Enter] key to resume..."
make install
mv -v /usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat} /bin
mv -v /usr/lib/liblzma.so.* /lib
ln -svf ../../lib/$(readlink /usr/lib/liblzma.so) /usr/lib/liblzma.so
cd /sources
rm -Rf xz-5.2.4

# Kmod-26 || Contains libraries and utilities for loading kernel modules || 0.1 SBUs
tar xvf kmod-26.tar.xz
cd kmod-26
./configure --prefix=/usr \
--bindir=/bin \
--sysconfdir=/etc \
--with-rootlibdir=/lib \
--with-xz \
--with-zlib
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make install
for target in depmod insmod lsmod modinfo modprobe rmmod; do
ln -sfv ../bin/kmod /sbin/$target
done
ln -sfv kmod /bin/lsmod
cd /sources
rm -Rf kmod-26

# Gettext-0.19.8.1 || Translates a natural language message into the user's language by looking up the translation in a message catalog || 2.0 SBUs
tar xvf gettext-0.19.8.1.tar.xz
cd gettext-0.19.8.1
sed -i '/^TESTS =/d' gettext-runtime/tests/Makefile.in &&
sed -i 's/test-lock..EXEEXT.//' gettext-tools/gnulib-tests/Makefile.in
sed -e '/AppData/{N;N;p;s/\.appdata\./.metainfo./}' \
-i gettext-tools/its/appdata.loc
./configure --prefix=/usr \
--disable-static \
--docdir=/usr/share/doc/gettext-0.19.8.1
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make check
read -p "Press [Enter] key to resume..."
make install
chmod -v 0755 /usr/lib/preloadable_libintl.so
cd /sources
rm -Rf gettext-0.19.8.1

# Elfutils-0.176 || For handling ELF (Executable and Linkable Format) files || 1.3 SBUs
tar xvf elfutils-0.176.tar.bz2
cd elfutils-0.176
./configure --prefix=/usr
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make check
read -p "Press [Enter] key to resume..."
make -C libelf install
install -vm644 config/libelf.pc /usr/lib/pkgconfig
cd /sources
rm -Rf elfutils-0.176

# Libffi-3.2.1 || Provides a portable, high level programming interface to various calling conventions || 0.3 SBUs
tar xvf libffi-3.2.1.tar.gz
cd libffi-3.2.1
sed -e '/^includesdir/ s/$(libdir).*$/$(includedir)/' \
-i include/Makefile.in
sed -e '/^includedir/ s/=.*$/=@includedir@/' \
-e 's/^Cflags: -I${includedir}/Cflags:/' \
-i libffi.pc.in
./configure --prefix=/usr --disable-static --with-gcc-arch=native
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make check
read -p "Press [Enter] key to resume..."
make install
cd /sources
rm -Rf libffi-3.2.1

# Openssl-1.1.1a || Contains management tools and libraries relating to cryptography || 1.7 SBUs
tar xvf openssl-1.1.1a.tar.gz
cd openssl-1.1.1a
./config --prefix=/usr \
--openssldir=/etc/ssl \
--libdir=lib \
shared \
zlib-dynamic
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make test
read -p "Press [Enter] key to resume..."
sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
make MANSUFFIX=ssl install
read -p "Press [Enter] key to resume..."
mv -v /usr/share/doc/openssl /usr/share/doc/openssl-1.1.1a
cp -vfr doc/* /usr/share/doc/openssl-1.1.1a
cd /sources
rm -Rf openssl-1.1.1a

# Python-3.7.2 || Contains the Python development environment || 1.0 SBUs
tar xvf Python-3.7.2.tar.xz
cd Python-3.7.2
./configure --prefix=/usr \
--enable-shared \
--with-system-expat \
--with-system-ffi \
--with-ensurepip=yes
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make install
chmod -v 755 /usr/lib/libpython3.7m.so
chmod -v 755 /usr/lib/libpython3.so
read -p "Press [Enter] key to resume..."
install -v -dm755 /usr/share/doc/python-3.7.2/html
tar --strip-components=1 \
--no-same-owner \
--no-same-permissions \
-C /usr/share/doc/python-3.7.2/html \
-xvf ../python-3.7.2-docs-html.tar.bz2
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf Python-3.7.2

# Ninja-1.9.0 || A small build system with a focus on speed || 0.2 SBUs
tar xvf ninja-1.9.0.tar.gz
cd ninja-1.9.0
sed -i '/int Guess/a \
int j = 0;\
char* jobs = getenv( "NINJAJOBS" );\
if ( jobs != NULL ) j = atoi( jobs );\
if ( j > 0 ) return j;\
' src/ninja.cc
read -p "Press [Enter] key to resume..."
python3 configure.py --bootstrap
read -p "Press [Enter] key to resume..."
python3 configure.py
./ninja ninja_test
./ninja_test --gtest_filter=-SubprocessTest.SetWithLots
read -p "Press [Enter] key to resume..."
install -vm755 ninja /usr/bin/
install -vDm644 misc/bash-completion /usr/share/bash-completion/completions/ninja
install -vDm644 misc/zsh-completion /usr/share/zsh/site-functions/_ninja
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf ninja-1.9.0

# Meson-0.49.2 || A small build system with a focus on speed || 0.2 SBUs
tar xvf meson-0.49.2.tar.gz
cd meson-0.49.2
read -p "Press [Enter] key to resume..."
python3 setup.py build
read -p "Press [Enter] key to resume..."
python3 setup.py install --root=dest
cp -rv dest/* /
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf meson-0.49.2

# Coreutils-8.30 || Contains utilities for showing and setting the basic system characteristics || 2.6 SBUs
tar xvf coreutils-8.30.tar.xz
cd coreutils-8.30
patch -Np1 -i ../coreutils-8.30-i18n-1.patch
sed -i '/test.lock/s/^/#/' gnulib-tests/gnulib.mk
autoreconf -fiv
FORCE_UNSAFE_CONFIGURE=1 ./configure \
--prefix=/usr \
--enable-no-install-program=kill,uptime
read -p "Press [Enter] key to resume..."
FORCE_UNSAFE_CONFIGURE=1 make
read -p "Press [Enter] key to resume..."
make NON_ROOT_USERNAME=nobody check-root
read -p "Press [Enter] key to resume..."
echo "dummy:x:1000:nobody" >> /etc/group
chown -Rv nobody .
su nobody -s /bin/bash \
-c "PATH=$PATH make RUN_EXPENSIVE_TESTS=yes check"
sed -i '/dummy/d' /etc/group
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
mv -v /usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} /bin
mv -v /usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm} /bin
mv -v /usr/bin/{rmdir,stty,sync,true,uname} /bin
mv -v /usr/bin/chroot /usr/sbin
mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
sed -i s/\"1\"/\"8\"/1 /usr/share/man/man8/chroot.8
mv -v /usr/bin/{head,nice,sleep,touch} /bin
cd /sources
rm -Rf coreutils-8.30

# Check-0.12.0 || A unit testing framework for C || 0.1 SBUs
tar xvf check-0.12.0.tar.gz
cd check-0.12.0
./configure --prefix=/usr
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
# WARNING VERY EXPENSIVE TEST || DO NOT RUN UNLESS YOU KNOW WHAT YOU ARE DOING
# make check
read -p "Press [Enter] key to resume..."
make install
sed -i '1 s/tools/usr/' /usr/bin/checkmk
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf check-0.12.0

# Diffutils-3.7 || Compares two files or directories and reports which lines in the files differ || 0.3 SBUs
tar xvf diffutils-3.7.tar.xz
cd diffutils-3.7
./configure --prefix=/usr
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make check
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf diffutils-3.7

# Gawk-4.2.1 || A program for manipulating text files || 0.3 SBUs
tar xvf gawk-4.2.1.tar.xz
cd gawk-4.2.1
sed -i 's/extras//' Makefile.in
./configure --prefix=/usr
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make check
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
mkdir -v /usr/share/doc/gawk-4.2.1
cp -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-4.2.1
cd /sources
rm -Rf gawk-4.2.1

# Findutils-4.6.0 || Contains programs to find files || 0.6 SBUs
tar xvf findutils-4.6.0.tar.gz
cd findutils-4.6.0
sed -i 's/test-lock..EXEEXT.//' tests/Makefile.in
sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' gl/lib/*.c
sed -i '/unistd/a #include <sys/sysmacros.h>' gl/lib/mountlist.c
echo "#define _IO_IN_BACKUP 0x100" >> gl/lib/stdio-impl.h
./configure --prefix=/usr --localstatedir=/var/lib/locate
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make check
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
mv -v /usr/bin/find /bin
sed -i 's|find:=${BINDIR}|find:=/bin|' /usr/bin/updatedb
cd /sources
rm -Rf findutils-4.6.0

# Groff-1.22.4 || Contains programs for processing and formatting text || 0.4 SBUs
tar xvf groff-1.22.4.tar.gz
cd groff-1.22.4
PAGE=<paper_size> ./configure --prefix=/usr
read -p "Press [Enter] key to resume..."
make -j1
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf groff-1.22.4

# GRUB-2.02 || Contains the GRand Unified Bootloader || 0.6 SBUs
tar xvf grub-2.02.tar.xz
cd grub-2.02
./configure --prefix=/usr \
--sbindir=/sbin \
--sysconfdir=/etc \
--disable-efiemu \
--disable-werror
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make install
mv -v /etc/bash_completion.d/grub /usr/share/bash-completion/completions
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf grub-2.02

# Less-530 || A file viewer or pager || 0.1 SBUs
tar xvf less-530.tar.gz
cd less-530
./configure --prefix=/usr --sysconfdir=/etc
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf less-530

# Gzip-1.10 || Contains programs for compressing and decompressing files || 0.1 SBUs
tar xvf gzip-1.10.tar.xz
cd gzip-1.10
./configure --prefix=/usr
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make check
read -p "Press [Enter] key to resume..."
make install
mv -v /usr/bin/gzip /bin
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf gzip-1.10

# iproute2-4.20.0 || Contains programs for basic and advanced IPV4-based networking || 0.2 SBUs
tar xvf iproute2-4.20.0.tar.xz
cd iproute2-4.20.0
sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8
sed -i 's/.m_ipt.o//' tc/Makefile
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make DOCDIR=/usr/share/doc/iproute2-4.20.0 install
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf iproute2-4.20.0

# Kbd-2.0.4 || Contains key-table files, console fonts, and keyboard utilities || 0.1 SBUs
tar xvf kbd-2.0.4.tar.xz
cd kbd-2.0.4
patch -Np1 -i ../kbd-2.0.4-backspace-1.patch
sed -i 's/\(RESIZECONS_PROGS=\)yes/\1no/g' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in
PKG_CONFIG_PATH=/tools/lib/pkgconfig ./configure --prefix=/usr --disable-vlock
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make check
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
mkdir -v /usr/share/doc/kbd-2.0.4
cp -R -v docs/doc/* /usr/share/doc/kbd-2.0.4
cd /sources
rm -Rf kbd-2.0.4

# Libpipeline-1.5.1 || This library is used to safely construct pipelines between subprocesses || 0.1 SBUs
tar xvf libpipeline-1.5.1.tar.gz
cd libpipeline-1.5.1
./configure --prefix=/usr
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make check
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf libpipeline-1.5.1

# Make-4.2.1 || Contains a program for compiling packages || 0.1 SBUs
tar xvf make-4.2.1.tar.bz2
cd make-4.2.1
sed -i '211,217 d; 219,229 d; 232 d' glob/glob.c
./configure --prefix=/usr
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make PERL5LIB=$PWD/tests/ check
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf make-4.2.1

# Patch-2.7.6 || Modifies files according to a patch file || 0.2 SBUs
tar xvf patch-2.7.6.tar.xz
cd patch-2.7.6
./configure --prefix=/usr
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make check
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf patch-2.7.6

# Man-DB-2.8.5 || contains programs for finding and viewing man pages || 0.3 SBUs
tar xvf man-db-2.8.5.tar.xz
cd man-db-2.8.5
./configure --prefix=/usr \
--docdir=/usr/share/doc/man-db-2.8.5 \
--sysconfdir=/etc \
--disable-setuid \
--enable-cache-owner=bin \
--with-browser=/usr/bin/lynx \
--with-vgrind=/usr/bin/vgrind \
--with-grap=/usr/bin/grap \
--with-systemdtmpfilesdir= \
--with-systemdsystemunitdir=
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make check
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf man-db-2.8.5

# Tar-1.31 || Creates, extracts files from, and lists the contents of archives || 1.7 SBUs
tar xvf tar-1.31.tar.xz
cd tar-1.31
sed -i 's/abort.*/FALLTHROUGH;/' src/extract.c
FORCE_UNSAFE_CONFIGURE=1 \
./configure --prefix=/usr \
--bindir=/bin
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make check
read -p "Press [Enter] key to resume..."
make install
make -C doc install-html docdir=/usr/share/doc/tar-1.31
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf tar-1.31

# Texinfo-6.5 || Contains programs for reading, writing, and converting info pages || 0.9 SBUs
tar xvf texinfo-6.5.tar.xz
cd texinfo-6.5
sed -i '5481,5485 s/({/(\\{/' tp/Texinfo/Parser.pm
./configure --prefix=/usr --disable-static
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make check
read -p "Press [Enter] key to resume..."
make install
make TEXMF=/usr/share/texmf install-tex
read -p "Press [Enter] key to resume..."
pushd /usr/share/info
rm -v dir
for f in *
do install-info $f dir 2>/dev/null
done
popd
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf texinfo-6.5

# Vim-8.1 || Contains a powerful text editor || 1.3 SBUs
tar xvf vim-8.1.tar.bz2
cd vim-8.1
echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h
./configure --prefix=/usr
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
LANG=en_US.UTF-8 make -j1 test &> vim-test.log
read -p "Press [Enter] key to resume..."
make install
ln -sv vim /usr/bin/vi
for L in /usr/share/man/{,*/}man1/vim.1; do
ln -sv vim.1 $(dirname $L)/vi.1
done
read -p "Press [Enter] key to resume..."
ln -sv ../vim/vim81/doc /usr/share/doc/vim-8.1
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf vim-8.1

# Procps-ng-3.3.15 || Contains programs for monitoring processes || 0.1 SBUs
tar xvf procps-ng-3.3.15.tar.xz
cd procps-ng-3.3.15
./configure --prefix=/usr \
--exec-prefix= \
--libdir=/usr/lib \
--docdir=/usr/share/doc/procps-ng-3.3.15 \
--disable-static \
--disable-kil
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
sed -i -r 's|(pmap_initname)\\\$|\1|' testsuite/pmap.test/pmap.exp
sed -i '/set tty/d' testsuite/pkill.test/pkill.exp
rm testsuite/pgrep.test/pgrep.exp
make check
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
mv -v /usr/lib/libprocps.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libprocps.so) /usr/lib/libprocps.so
cd /sources
rm -Rf procps-ng-3.3.15

# Util-linux-2.33.1 || Contains miscellaneous utility programs || 1.5 SBUs
tar xvf util-linux-2.33.1.tar.xz
cd util-linux-2.33.1
mkdir -pv /var/lib/hwclock
rm -vf /usr/include/{blkid,libmount,uuid}
./configure ADJTIME_PATH=/var/lib/hwclock/adjtime \
--docdir=/usr/share/doc/util-linux-2.33.1 \
--disable-chfn-chsh \
--disable-login \
--disable-nologin \
--disable-su \
--disable-setpriv \
--disable-runuser \
--disable-pylibmount \
--disable-static \
--without-python \
--without-systemd \
--without-systemdsystemunitdir
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
#  RUNNING THE TEST SUITE CAN BE HARMFUL TO YOUR SYSTEM || DO NOT RUN UNLESS YOU KNOW WHAT YOU ARE DOING
# chown -Rv nobody .
# su nobody -s /bin/bash -c "PATH=$PATH make -k check"
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf util-linux-2.33.1

# E2fsprogs-1.44.5 || Contains the utilities for handling the ext2 file system || 1.6 SBUs
tar xvf e2fsprogs-1.44.5.tar.gz
cd e2fsprogs-1.44.5
mkdir -v build
cd build
Prepare E2fsprogs for compilation:
../configure --prefix=/usr \
--bindir=/bin \
--with-root-prefix="" \
--enable-elf-shlibs \
--disable-libblkid \
--disable-libuuid \
--disable-uuidd \
--disable-fsck
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
# One of the E2fsprogs tests will attempt to allocate 256 MB of memory. If you do not have significantly more RAM
than this, be sure to enable sufficient swap space for the test.
make check
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
make install-libs
chmod -v u+w /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a
read -p "Press [Enter] key to resume..."
gunzip -v /usr/share/info/libext2fs.info.gz
install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info
makeinfo -o doc/com_err.info ../lib/et/com_err.texinfo
install -v -m644 doc/com_err.info /usr/share/info
install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf e2fsprogs-1.44.5

# Sysklogd-1.5.1 || Contains programs for logging system messages || 0.1 SBUs
tar xvf sysklogd-1.5.1.tar.gz
cd sysklogd-1.5.1
sed -i '/Error loading kernel symbols/{n;n;d}' ksym_mod.c
sed -i 's/union wait/int/' syslogd.c
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make BINDIR=/sbin install
read -p "Press [Enter] key to resume..."
cat > /etc/syslog.conf << "EOF"
# Begin /etc/syslog.conf
auth,authpriv.* -/var/log/auth.log
*.*;auth,authpriv.none -/var/log/sys.log
daemon.* -/var/log/daemon.log
kern.* -/var/log/kern.log
mail.* -/var/log/mail.log
user.* -/var/log/user.log
*.emerg *
# End /etc/syslog.conf
EOF
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf sysklogd-1.5.1

# Sysvinit-2.93 || Contains programs for controlling the startup, running, and shutdown of the system || 0.1 SBUs
tar xvf sysvinit-2.93.tar.xz
cd sysvinit-2.93
patch -Np1 -i ../sysvinit-2.93-consolidated-1.patch
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf sysvinit-2.93

# Eudev-3.2.7 || Contains programs for dynamic creation of device nodes || 0.2 SBUs
tar xvf eudev-3.2.7.tar.gz
cd eudev-3.2.7
cat > config.cache << "EOF"
HAVE_BLKID=1
BLKID_LIBS="-lblkid"
BLKID_CFLAGS="-I/tools/include"
EOF
./configure --prefix=/usr \
--bindir=/sbin \
--sbindir=/sbin \
--libdir=/usr/lib \
--sysconfdir=/etc \
--libexecdir=/lib \
--with-rootprefix= \
--with-rootlibdir=/lib \
--enable-manpages \
--disable-static \
--config-cache
read -p "Press [Enter] key to resume..."
LIBRARY_PATH=/tools/lib make
read -p "Press [Enter] key to resume..."
mkdir -pv /lib/udev/rules.d
mkdir -pv /etc/udev/rules.d
make LD_LIBRARY_PATH=/tools/lib check
read -p "Press [Enter] key to resume..."
make LD_LIBRARY_PATH=/tools/lib install
read -p "Press [Enter] key to resume..."
tar -xvf ../udev-lfs-20171102.tar.bz2
make -f udev-lfs-20171102/Makefile.lfs install
read -p "Press [Enter] key to resume..."
LD_LIBRARY_PATH=/tools/lib udevadm hwdb --update
cd /sources
rm -Rf eudev-3.2.7