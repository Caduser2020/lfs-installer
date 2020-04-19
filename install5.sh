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

# Expat-2.2.9 || Contains a stream oriented C library for parsing XML || 0.1 SBUs
tar xvf expat-2.2.9.tar.xz
cd expat-2.2.9
sed -i 's|usr/bin/env |bin/|' run.sh.in
./configure --prefix=/usr \
--disable-static \
--docdir=/usr/share/doc/expat-2.2.9
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make check
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
install -v -m644 doc/*.{html,png,css} /usr/share/doc/expat-2.2.9
cd /sources
rm -Rf expat-2.2.9

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

# Perl-5.30.1 || Contains the Practical Extraction and Report Language || 9.2 SBUs
tar xvf perl-5.30.1.tar.xz
cd perl-5.30.1
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
# ! VERY EXPENSIVE TEST (11 SBU)
# make test
# read -p "Press [Enter] key to resume..."
make install
unset BUILD_ZLIB BUILD_BZIP2
cd /sources
rm -Rf perl-5.30.1

# XML-Parser-2.46 || Provides the Perl Expat interface|| less than 0.1 SBUs
tar xvf XML-Parser-2.46.tar.gz
cd XML-Parser-2.46
perl Makefile.PL
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make test
read -p "Press [Enter] key to resume..."
make install
cd /sources
rm -Rf XML-Parser-2.46

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
# ! BROKEN TEST
# make check
# read -p "Press [Enter] key to resume..."
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
# ! EXPENSIVE TEST (8.6 SBU)
# make -j4 check
# read -p "Press [Enter] key to resume..."
make install
cd /sources
rm -Rf automake-1.16.1

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

# Gettext-0.20.1 || Translates a natural language message into the user's language by looking up the translation in a message catalog || 2.0 SBUs
tar xvf gettext-0.20.1.tar.xz
cd gettext-0.20.1
./configure --prefix=/usr \
--disable-static \
--docdir=/usr/share/doc/gettext-0.20.1
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make check
read -p "Press [Enter] key to resume..."
make install
chmod -v 0755 /usr/lib/preloadable_libintl.so
cd /sources
rm -Rf gettext-0.20.1

# Libelf from Elfutils-0.178 || Library for handling ELF (Executable and Linkable Format) files || 1.1 SBUs
tar xvf elfutils-0.178.tar.bz2
cd elfutils-0.178
./configure --prefix=/usr --disable-debuginfod
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make check
read -p "Press [Enter] key to resume..."
make -C libelf install
install -vm644 config/libelf.pc /usr/lib/pkgconfig
rm /usr/lib/libelf.a
cd /sources
rm -Rf elfutils-0.178

# Libffi-3.3 || Provides a portable, high level programming interface to various calling conventions || 0.4 SBUs
tar xvf libffi-3.3.tar.gz
cd libffi-3.3
./configure --prefix=/usr --disable-static --with-gcc-arch=native
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make check
read -p "Press [Enter] key to resume..."
make install
cd /sources
rm -Rf libffi-3.3

# Openssl-1.1.1d || Contains management tools and libraries relating to cryptography || 2.3 SBUs
tar xvf openssl-1.1.1d.tar.gz
cd openssl-1.1.1d
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
mv -v /usr/share/doc/openssl /usr/share/doc/openssl-1.1.1d
cp -vfr doc/* /usr/share/doc/openssl-1.1.1d
cd /sources
rm -Rf openssl-1.1.1d

# Python-3.8.1 || Contains the Python development environment || 1.3 SBUs
tar xvf Python-3.8.1.tar.xz
cd Python-3.8.1
./configure --prefix=/usr \
--enable-shared \
--with-system-expat \
--with-system-ffi \
--with-ensurepip=yes
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make install
chmod -v 755 /usr/lib/libpython3.8m.so
chmod -v 755 /usr/lib/libpython3.so
ln -sfv pip3.8 /usr/bin/pip3
install -v -dm755 /usr/share/doc/python-3.8.1/html
tar --strip-components=1 \
 --no-same-owner \
 --no-same-permissions \
 -C /usr/share/doc/python-3.8.1/html \
 -xvf ../python-3.8.1-docs-html.tar.bz2
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf Python-3.8.1

# Ninja-1.10.0 || A small build system with a focus on speed || 0.2 SBUs
tar xvf ninja-1.10.0.tar.gz
cd ninja-1.10.0
sed -i '/int Guess/a \
int j = 0;\
char* jobs = getenv( "NINJAJOBS" );\
if ( jobs != NULL ) j = atoi( jobs );\
if ( j > 0 ) return j;\
' src/ninja.cc
read -p "Press [Enter] key to resume..."
python3 configure.py --bootstrap
read -p "Press [Enter] key to resume..."
./ninja ninja_test
./ninja_test --gtest_filter=-SubprocessTest.SetWithLots
read -p "Press [Enter] key to resume..."
install -vm755 ninja /usr/bin/
install -vDm644 misc/bash-completion /usr/share/bash-completion/completions/ninja
install -vDm644 misc/zsh-completion  /usr/share/zsh/site-functions/_ninja
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf ninja-1.10.0

# Meson-0.53.1 || open source build system meant to be both extremely fast and user friendly || less than 0.1 SBUs
tar xvf meson-0.53.1.tar.gz
cd meson-0.53.1
read -p "Press [Enter] key to resume..."
python3 setup.py build
read -p "Press [Enter] key to resume..."
python3 setup.py install --root=dest
cp -rv dest/* /
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf meson-0.53.1

# Coreutils-8.31 || Contains utilities for showing and setting the basic system characteristics || 2.3 SBUs
tar xvf coreutils-8.31.tar.xz
cd coreutils-8.31
patch -Np1 -i ../coreutils-8.31-i18n-1.patch
sed -i '/test.lock/s/^/#/' gnulib-tests/gnulib.mk
autoreconf -fiv
FORCE_UNSAFE_CONFIGURE=1 ./configure \
 --prefix=/usr \
 --enable-no-install-program=kill,uptime
read -p "Press [Enter] key to resume..."
make
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
rm -Rf coreutils-8.31

# Check-0.14.0 || A unit testing framework for C || 0.1 SBUs
tar xvf check-0.14.0.tar.gz
cd check-0.14.0
./configure --prefix=/usr
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
# ! EXPENSIVE TEST (3.6 to 4 SBUs)
# make check
# read -p "Press [Enter] key to resume..."
make docdir=/usr/share/doc/check-0.14.0 install
sed -i '1 s/tools/usr/' /usr/bin/checkmk
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf check-0.14.0

# Diffutils-3.7 || Compares two files or directories and reports which lines in the files differ || 0.4 SBUs
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

# Gawk-5.0.1 || A program for manipulating text files || 0.4 SBUs
tar xvf gawk-5.0.1.tar.xz
cd gawk-5.0.1
sed -i 's/extras//' Makefile.in
./configure --prefix=/usr
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make check
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
mkdir -v /usr/share/doc/gawk-5.0.1
cp -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-5.0.1
cd /sources
rm -Rf gawk-5.0.1

# Findutils-4.7.0 || Contains programs to find files || 0.7 SBUs
tar xvf findutils-4.7.0.tar.gz
cd findutils-4.7.0
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
rm -Rf findutils-4.7.0

# Groff-1.22.4 || Contains programs for processing and formatting text || 0.5 SBUs
tar xvf groff-1.22.4.tar.gz
cd groff-1.22.4
PAGE=letter ./configure --prefix=/usr
read -p "Press [Enter] key to resume..."
make -j1
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf groff-1.22.4

# GRUB-2.04 || Contains the GRand Unified Bootloader || 0.8 SBUs
tar xvf grub-2.04.tar.xz
cd grub-2.04
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
rm -Rf grub-2.04

# Less-551 || A file viewer or pager || less than 0.1 SBUs
tar xvf less-551.tar.gz
cd less-551
./configure --prefix=/usr --sysconfdir=/etc
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf less-541

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

# Zstd-1.4.4 || Real-time compression algorithm, providing high compression ratios. || 0.7 SBUs
tar xvf zstd-1.4.4.tar.gz
cd zstd-1.4.4
make
read -p "Press [Enter] key to resume..."
make prefix=/usr install
read -p "Press [Enter] key to resume..."
rm -v /usr/lib/libzstd.a
mv -v /usr/lib/libzstd.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libzstd.so) /usr/lib/libzstd.so
cd /sources
rm -Rf zstd-1.4.4

# iproute2-5.5.0 || Contains programs for basic and advanced IPV4-based networking || 0.2 SBUs
tar xvf iproute2-5.5.0.tar.xz
cd iproute2-5.5.0
sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8
sed -i 's/.m_ipt.o//' tc/Makefile
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make DOCDIR=/usr/share/doc/iproute2-5.5.0 install
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf iproute2-5.5.0

# Kbd-2.2.0 || Contains key-table files, console fonts, and keyboard utilities || 0.1 SBUs
tar xvf kbd-2.2.0.tar.xz
cd kbd-2.2.0
patch -Np1 -i ../kbd-2.2.0-backspace-1.patch
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
mkdir -v /usr/share/doc/kbd-2.2.0
cp -R -v docs/doc/* /usr/share/doc/kbd-2.2.0
cd /sources
rm -Rf kbd-2.2.0

# Libpipeline-1.5.2 || This library is used to safely construct pipelines between subprocesses || 0.1 SBUs
tar xvf libpipeline-1.5.2.tar.gz
cd libpipeline-1.5.2
./configure --prefix=/usr
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make check
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf libpipeline-1.5.2

# Make-4.3 || Contains a program for compiling packages || 0.6 SBUs
tar xvf make-4.3.tar.gz
cd make-4.3
./configure --prefix=/usr
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make PERL5LIB=$PWD/tests/ check
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf make-4.3

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

# Man-DB-2.9.0 || contains programs for finding and viewing man pages || 0.4 SBUs
tar xvf man-db-2.9.0.tar.xz
cd man-db-2.9.0
./configure --prefix=/usr \
 --docdir=/usr/share/doc/man-db-2.9.0 \
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
rm -Rf man-db-2.9.0

# Tar-1.32 || Creates, extracts files from, and lists the contents of archives || 2.2 SBUs
tar xvf tar-1.32.tar.xz
cd tar-1.32
FORCE_UNSAFE_CONFIGURE=1 \
./configure --prefix=/usr \
--bindir=/bin
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
# ! EXPENSIVE TEST (3.0 SBU) 
# make check
# read -p "Press [Enter] key to resume..."
make install
make -C doc install-html docdir=/usr/share/doc/tar-1.32
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf tar-1.32

# Texinfo-6.7 || Contains programs for reading, writing, and converting info pages || 0.8 SBUs
tar xvf texinfo-6.7.tar.xz
cd texinfo-6.7
./configure --prefix=/usr --disable-static
echo "In this case, the top-level configure script will complain that this is an unrecognized option, but the configure \
script for XSParagraph recognizes it and uses it to disable installing a static XSParagraph.a to /usr/lib/\
texinfo."
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
rm -Rf texinfo-6.7

# Vim-8.2.0190 || Contains a powerful text editor || 1.7 SBUs
tar xvf vim-8.2.0190.tar.gz
cd vim-8.2.0190
echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h
./configure --prefix=/usr
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
chown -Rv nobody .
su nobody -s /bin/bash -c "LANG=en_US.UTF-8 make -j1 test" &> vim-test.log
read -p "Press [Enter] key to resume..."
make install
ln -sv vim /usr/bin/vi
for L in /usr/share/man/{,*/}man1/vim.1; do
	ln -sv vim.1 $(dirname $L)/vi.1
done
ln -sv ../vim/vim82/doc /usr/share/doc/vim-8.2.0190
read -p "Press [Enter] key to resume..."
cat > /etc/vimrc << "EOF"
" Begin /etc/vimrc
" Ensure defaults are set before customizing settings, not after
source $VIMRUNTIME/defaults.vim
let skip_defaults_vim=1
set nocompatible
set backspace=2
set mouse=
syntax on
if (&term == "xterm") || (&term == "putty")
	set background=dark
endif
" End /etc/vimrc
EOF

cd /sources
rm -Rf vim-8.2.0190

# Procps-ng-3.3.15 || Contains programs for monitoring processes || 0.1 SBUs
tar xvf procps-ng-3.3.15.tar.xz
cd procps-ng-3.3.15
./configure --prefix=/usr \
 --exec-prefix= \
 --libdir=/usr/lib \
 --docdir=/usr/share/doc/procps-ng-3.3.15 \
 --disable-static \
 --disable-kill
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

# Util-linux-2.35.1 || Contains miscellaneous utility programs || 1.2 SBUs
tar xvf util-linux-2.35.1.tar.xz
cd util-linux-2.35.1
mkdir -pv /var/lib/hwclock
./configure ADJTIME_PATH=/var/lib/hwclock/adjtime \
	--docdir=/usr/share/doc/util-linux-2.35.1 \
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
# ! Running the test suite can be harmful to your system. || Requires CONFIG_SCSI_DEBUG
# chown -Rv nobody .
# su nobody -s /bin/bash -c "PATH=$PATH make -k check"
# read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf util-linux-2.35.1

# E2fsprogs-1.45.5 || Contains the utilities for handling the ext2 file system || 3.1 SBUs
tar xvf e2fsprogs-1.45.5.tar.gz
cd e2fsprogs-1.45.5
mkdir -v build
cd build
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
echo "One of the E2fsprogs tests will attempt to allocate 256 MB of memory. If you do not have significantly more RAM\n"
echo "than this, be sure to enable sufficient swap space for the test."
read -p "Press [Enter] key to resume..."
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
rm -Rf e2fsprogs-1.45.5

# Sysklogd-1.5.1 || Contains programs for logging system messages || 0.1 SBUs
tar xvf sysklogd-1.5.1.tar.gz
cd sysklogd-1.5.1
sed -i '/Error loading kernel symbols/{n;n;d}' ksym_mod.c
sed -i 's/union wait/int/' syslogd.c
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make BINDIR=/sbin install
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

# Sysvinit-2.96 || Contains programs for controlling the startup, running, and shutdown of the system || 0.1 SBUs
tar xvf sysvinit-2.96.tar.xz
cd sysvinit-2.96
patch -Np1 -i ../sysvinit-2.96-consolidated-1.patch
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /sources
rm -Rf sysvinit-2.96

# Eudev-3.2.9 || Contains programs for dynamic creation of device nodes || 0.2 SBUs
tar xvf eudev-3.2.9.tar.gz
cd eudev-3.2.9
./configure --prefix=/usr \
 --bindir=/sbin \
 --sbindir=/sbin \
 --libdir=/usr/lib \
 --sysconfdir=/etc \
 --libexecdir=/lib \
 --with-rootprefix= \
 --with-rootlibdir=/lib \
 --enable-manpages \
 --disable-static
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
mkdir -pv /lib/udev/rules.d
mkdir -pv /etc/udev/rules.d
make check
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
tar -xvf ../udev-lfs-20171102.tar.xz
make -f udev-lfs-20171102/Makefile.lfs install
read -p "Press [Enter] key to resume..."
udevadm hwdb --update
cd /sources
rm -Rf eudev-3.2.9

bash $shdir/install6.sh
