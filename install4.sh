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

cd /sources || exit 1
export LFS=/mnt/lfs

# Pkg-config-0.29.2 || Returns meta information for the specified library or package || 0.3 SBUs
tar xvf pkg-config-0.29.2.tar.gz
(
  cd pkg-config-0.29.2 || exit 1
  ./configure --prefix=/usr \
    --with-internal-glib \
    --disable-host-tool \
    --docdir=/usr/share/doc/pkg-config-0.29.2
  read -r -p "Press [Enter] key to resume..."
  make
  read -r -p "Press [Enter] key to resume..."
  make check
  read -r -p "Press [Enter] key to resume..."
  make install
  read -r -p "Press [Enter] key to resume..."
)
rm -Rf pkg-config-0.29.2

# Ncurses-6.2 || Contains libraries for terminal-independent handling of character screens || 0.4 SBUs
tar xvf ncurses-6.2.tar.gz
(
  cd ncurses-6.2 || exit 1
  sed -i '/LIBTOOL_INSTALL/d' c++/Makefile.in
  ./configure --prefix=/usr \
    --mandir=/usr/share/man \
    --with-shared \
    --without-debug \
    --without-normal \
    --enable-pc-files \
    --enable-widec
  read -r -p "Press [Enter] key to resume..."
  make
  read -r -p "Press [Enter] key to resume..."
  make install
  read -r -p "Press [Enter] key to resume..."
  mv -v /usr/lib/libncursesw.so.6* /lib
  ln -sfv "../../lib/$(readlink /usr/lib/libncursesw.so)" /usr/lib/libncursesw.so
  for lib in ncurses form panel menu; do
    rm -vf /usr/lib/lib${lib}.so
    echo "INPUT(-l${lib}w)" >/usr/lib/lib${lib}.so
    ln -sfv ${lib}w.pc /usr/lib/pkgconfig/${lib}.pc
  done
  rm -vf /usr/lib/libcursesw.so
  echo "INPUT(-lncursesw)" >/usr/lib/libcursesw.so
  ln -sfv libncurses.so /usr/lib/libcurses.so
  mkdir -v /usr/share/doc/ncurses-6.2
  cp -v -R doc/* /usr/share/doc/ncurses-6.2
  read -r -p "Press [Enter] key to resume..."
)
rm -Rf ncurses-6.2

# Libcap-2.31 || Contains the library functions for manipulating POSIX 1003.1e capabilities || 0.1 SBUs
tar xvf libcap-2.31.tar.xz
(
  cd libcap-2.31 || exit 1
  sed -i '/install.*STA...LIBNAME/d' libcap/Makefile
  read -r -p "Press [Enter] key to resume..."
  make lib=lib
  read -r -p "Press [Enter] key to resume..."
  make test
  read -r -p "Press [Enter] key to resume..."
  make lib=lib install
  chmod -v 755 /lib/libcap.so.2.31
  read -r -p "Press [Enter] key to resume..."
)
rm -Rf libcap-2.31

# Sed-4.8 || Filters and transforms text files in a single pass || 0.3 SBUs
tar xvf sed-4.8.tar.xz
(
  cd sed-4.8 || exit 1
  sed -i 's/usr/tools/' build-aux/help2man
  sed -i 's/testsuite.panic-tests.sh//' Makefile.in
  ./configure --prefix=/usr --bindir=/bin
  read -r -p "Press [Enter] key to resume..."
  make
  make html
  read -r -p "Press [Enter] key to resume..."
  make check
  read -r -p "Press [Enter] key to resume..."
  make install
  install -d -m755 /usr/share/doc/sed-4.8
  install -m644 doc/sed.html /usr/share/doc/sed-4.8
  read -r -p "Press [Enter] key to resume..."
)
rm -Rf sed-4.8

# Psmisc-23.2 || Contains programs for displaying information about running processes || less than 0.1 SBUs
tar xvf psmisc-23.2.tar.xz
(
  cd psmisc-23.2 || exit 1
  ./configure --prefix=/usr
  make
  read -r -p "Press [Enter] key to resume..."
  make install
  read -r -p "Press [Enter] key to resume..."
  mv -v /usr/bin/fuser /bin
  mv -v /usr/bin/killall /bin
)
rm -Rf psmisc-23.2

# Iana-etc-2.30 || Provides data for network services and protocol || 0.1 SBUs
tar xvf iana-etc-2.30.tar.bz2
(
  cd iana-etc-2.30 || exit 1
  make
  read -r -p "Press [Enter] key to resume..."
  make install
  read -r -p "Press [Enter] key to resume..."
)
rm -Rf iana-etc-2.30

# Bison-3.5.2 || Contains a parser generator || 0.3 SBUs
tar xvf bison-3.5.2.tar.xz
(
  cd bison-3.5.2 || exit 1
  ./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.5.2
  read -r -p "Press [Enter] key to resume..."
  make
  read -r -p "Press [Enter] key to resume..."
  make install
  read -r -p "Press [Enter] key to resume..."
)
rm -Rf bison-3.5.2

# flex-2.6.4 || A tool for generating programs that recognize patterns in text || 0.9 SBUs
tar xvf flex-2.6.4.tar.gz
(
  cd flex-2.6.4 || exit 1
  sed -i "/math.h/a #include <malloc.h>" src/flexdef.h
  HELP2MAN=/tools/bin/true \
    ./configure --prefix=/usr --docdir=/usr/share/doc/flex-2.6.4
  read -r -p "Press [Enter] key to resume..."
  make
  read -r -p "Press [Enter] key to resume..."
  make check
  read -r -p "Press [Enter] key to resume..."
  make install
  read -r -p "Press [Enter] key to resume..."
  ln -sv flex /usr/bin/lex
)
rm -Rf flex-2.6.4

# Grep-3.4 || Contains programs for searching through files || 0.7 SBUs
tar xvf grep-3.4.tar.xz
(
  cd grep-3.4 || exit 1
  ./configure --prefix=/usr --bindir=/bin
  read -r -p "Press [Enter] key to resume..."
  make
  read -r -p "Press [Enter] key to resume..."
  make check
  read -r -p "Press [Enter] key to resume..."
  make install
  read -r -p "Press [Enter] key to resume..."
)
rm -Rf grep-3.4

# bash-5.0 || A widely-used command interpreter || 2.1 SBUs
tar xvf bash-5.0.tar.gz
(
  cd bash-5.0 || exit 1
  patch -Np1 -i ../bash-5.0-upstream_fixes-1.patch
  ./configure --prefix=/usr \
    --docdir=/usr/share/doc/bash-5.0 \
    --without-bash-malloc \
    --with-installed-readline
  read -r -p "Press [Enter] key to resume..."
  make
  read -r -p "Press [Enter] key to resume..."
  chown -Rv nobody .
  su nobody -s /bin/bash -c "PATH=$PATH HOME=/home make tests"
  read -r -p "Press [Enter] key to resume..."
  make install
  read -r -p "Press [Enter] key to resume..."
  mv -vf /usr/bin/bash /bin
)
echo "Now run bash '/shdir/install5.sh' to continue."
exec /bin/bash --login +h
