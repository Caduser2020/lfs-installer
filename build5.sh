#!/bin/bash
#===================================================================================
#
# Builds text suite for Linux From Scratch 9.1 on a Red Hat based distribution of linux, such as Fedora, CentOS, or RHEL.
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

cd /mnt/lfs/sources || exit 1
export LFS=/mnt/LFS
MAKEFLAGS="-j$(nproc)"
export MAKEFLAGS

# M4-1.4.18 || Contains a macro-processor || 0.2 SBUs
tar xvf m4-1.4.18.tar.xz
(
  cd m4-1.4.18 || exit 1
  sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' lib/*.c
  echo "#define _IO_IN_BACKUP 0x100" >>lib/stdio-impl.h
  ./configure --prefix=/tools
  read -r -p "Press [Enter] key to resume..."
  make
  read -r -p "Press [Enter] key to resume..."
  make install
  read -r -p "Press [Enter] key to resume..."
)
rm -Rf m4-1.4.18

# Ncurses-6.2 || Contains  libraries for terminal-independent handling of character screens || 0.6 SBUs
tar xvf ncurses-6.2.tar.gz
(
  cd ncurses-6.2 || exit 1
  sed -i s/mawk// configure
  ./configure --prefix=/tools \
    --with-shared \
    --without-debug \
    --without-ada \
    --enable-widec \
    --enable-overwrite
  read -r -p "Press [Enter] key to resume..."
  make
  read -r -p "Press [Enter] key to resume..."
  make install
  ln -s libncursesw.so /tools/lib/libncurses.so
  read -r -p "Press [Enter] key to resume..."
)
rm -Rf ncurses-6.2

# Bash-5.0 || Contains Bourne-Again SHell || 0.4 SBUs
tar xvf bash-5.0.tar.gz
(
  cd bash-5.0 || exit 1
  ./configure --prefix=/tools --without-bash-malloc
  read -r -p "Press [Enter] key to resume..."
  make
  read -r -p "Press [Enter] key to resume..."
  make install
  ln -sv bash /tools/bin/sh
  read -r -p "Press [Enter] key to resume..."
)
rm -Rf bash-5.0

# Bison-3.5.2 || Contains parser generator || 0.3 SBUs
tar xvf bison-3.5.2.tar.xz
(
  cd bison-3.5.2 || exit 1
  ./configure --prefix=/tools
  read -r -p "Press [Enter] key to resume..."
  make
  read -r -p "Press [Enter] key to resume..."
  make install
  read -r -p "Press [Enter] key to resume..."
)
rm -Rf bison-3.5.2

# Bzip2-1.0.8 || Contains programs for compressing and decompressing files || less than 0.1 SBUs
tar xvf bzip2-1.0.8.tar.gz
(
  cd bzip2-1.0.8 || exit 1
  make -f Makefile-libbz2_so
  make clean
  read -r -p "Press [Enter] key to resume..."
  make
  read -r -p "Press [Enter] key to resume..."
  make PREFIX=/tools install
  cp -v bzip2-shared /tools/bin/bzip2
  cp -av libbz2.so* /tools/lib
  ln -sv libbz2.so.1.0 /tools/lib/libbz2.so
  read -r -p "Press [Enter] key to resume..."
)
rm -Rf bzip2-1.0.8

# Coreutils-8.31 || Contains utilities for showing and setting the basic system characteristics || 0.7 SBUs
tar xvf coreutils-8.31.tar.xz
(
  cd coreutils-8.31 || exit 1
  ./configure --prefix=/tools --enable-install-program=hostname
  read -r -p "Press [Enter] key to resume..."
  make
  read -r -p "Press [Enter] key to resume..."
  make install
  read -r -p "Press [Enter] key to resume..."
)
rm -Rf coreutils-8.31

# Diffutils-3.7 || Contains programs that show the differences between files or directories || 0.2 SBUs
tar xvf diffutils-3.7.tar.xz
(
  cd diffutils-3.7 || exit 1
  ./configure --prefix=/tools
  read -r -p "Press [Enter] key to resume..."
  make
  read -r -p "Press [Enter] key to resume..."
  make install
  read -r -p "Press [Enter] key to resume..."
)
rm -Rf diffutils-3.7

# file-5.38 || Contains a utility for determining the type of a given file or files || 0.1 SBUs
tar xvf file-5.38.tar.gz
(
  cd file-5.38 || exit 1
  ./configure --prefix=/tools
  read -r -p "Press [Enter] key to resume..."
  make
  read -r -p "Press [Enter] key to resume..."
  make install
  read -r -p "Press [Enter] key to resume..."
)
rm -Rf file-5.38

# Findutils-4.7.0 || Contains programs to find files || 0.3 SBUs
tar xvf findutils-4.7.0.tar.gz
(
  cd findutils-4.7.0 || exit 1
  ./configure --prefix=/tools
  read -r -p "Press [Enter] key to resume..."
  make
  read -r -p "Press [Enter] key to resume..."
  make install
  read -r -p "Press [Enter] key to resume..."
)
rm -Rf findutils-4.7.0

# Gawk-5.0.1 || Contains programs for manipulating text filess || 0.2 SBUs
tar xvf gawk-5.0.1.tar.xz
(
  cd gawk-5.0.1 || exit 1
  ./configure --prefix=/tools
  read -r -p "Press [Enter] key to resume..."
  make
  read -r -p "Press [Enter] key to resume..."
  make install
  read -r -p "Press [Enter] key to resume..."
)
rm -Rf gawk-5.0.1

# Gettext-0.20.1 || Contains utilities for internationalization and localization || 1.6 SBUs
tar xvf gettext-0.20.1.tar.xz
(
  cd gettext-0.20.1 || exit 1
  ./configure --disable-shared
  read -r -p "Press [Enter] key to resume..."
  make
  cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /tools/bin
  read -r -p "Press [Enter] key to resume..."
)
rm -Rf gettext-0.20.1

# Grep-3.4 || Contains programs for searching through files || 0.2 SBUs
tar xvf grep-3.4.tar.xz
(
  cd grep-3.4 || exit 1
  ./configure --prefix=/tools
  read -r -p "Press [Enter] key to resume..."
  make
  read -r -p "Press [Enter] key to resume..."
  make install
  read -r -p "Press [Enter] key to resume..."
)
rm -Rf grep-3.4

# Gzip-1.10 || Contains  programs for compressing and decompressing || 0.1 SBUs
tar xvf gzip-1.10.tar.xz
(
  cd gzip-1.10 || exit 1
  ./configure --prefix=/tools
  read -r -p "Press [Enter] key to resume..."
  make
  read -r -p "Press [Enter] key to resume..."
  make install
  read -r -p "Press [Enter] key to resume..."
)
rm -Rf gzip-1.10

# Make-4.3 || Contains a program for compiling packages || 0.1 SBUs
tar xvf make-4.3.tar.gz
(
  cd make-4.3 || exit 1
  ./configure --prefix=/tools --without-guile
  read -r -p "Press [Enter] key to resume..."
  make
  read -r -p "Press [Enter] key to resume..."
  make install
  read -r -p "Press [Enter] key to resume..."
)
rm -Rf make-4.3

# Patch-2.7.6 || Contains a program for modifying or creating files by applying a “patch” file typically created by the diff program || 0.2 SBUs
tar xvf patch-2.7.6.tar.xz
(
  cd patch-2.7.6 || exit 1
  ./configure --prefix=/tools
  read -r -p "Press [Enter] key to resume..."
  make
  read -r -p "Press [Enter] key to resume..."
  make install
  read -r -p "Press [Enter] key to resume..."
)
rm -Rf patch-2.7.6

# Perl-5.30.1 || Contains the Practical Extraction and Report Language || 1.5 SBUs
tar xvf perl-5.30.1.tar.xz
(
  cd perl-5.30.1 || exit 1
  sh Configure -des -Dprefix=/tools -Dlibs=-lm -Uloclibpth -Ulocincpth
  read -r -p "Press [Enter] key to resume..."
  make
  read -r -p "Press [Enter] key to resume..."
  cp -v perl cpan/podlators/scripts/pod2man /tools/bin
  mkdir -pv /tools/lib/perl5/5.30.1
  cp -Rv lib/* /tools/lib/perl5/5.30.1
  read -r -p "Press [Enter] key to resume..."
)
rm -Rf perl-5.30.1

# Python-3.8.1 || Contains the Python development environment  || 1.3 SBUs
tar xvf Python-3.8.1.tar.xz
(
  cd Python-3.8.1 || exit 1
  sed -i '/def add_multiarch_paths/a \        return' setup.py
  ./configure --prefix=/tools --without-ensurepip
  read -r -p "Press [Enter] key to resume..."
  make
  read -r -p "Press [Enter] key to resume..."
  make install
  read -r -p "Press [Enter] key to resume..."
)
rm -Rf Python-3.8.1

# Sed-4.8 || Contains a stream editor  || 0.2 SBUs
tar xvf sed-4.8.tar.xz
(
  cd sed-4.8 || exit 1
  ./configure --prefix=/tools
  read -r -p "Press [Enter] key to resume..."
  make
  read -r -p "Press [Enter] key to resume..."
  make install
  read -r -p "Press [Enter] key to resume..."
)
rm -Rf sed-4.8

# Tar-1.32 || Contains an archiving program  || 0.3 SBUs
tar xvf tar-1.32.tar.xz
(
  cd tar-1.32 || exit 1
  ./configure --prefix=/tools
  read -r -p "Press [Enter] key to resume..."
  make
  read -r -p "Press [Enter] key to resume..."
  make install
  read -r -p "Press [Enter] key to resume..."
)
rm -Rf tar-1.32

# texinfo-6.7 || programs for reading, writing, and converting info pages || 0.2 SBUs
tar xvf texinfo-6.7.tar.xz
(
  cd texinfo-6.7 || exit 1
  ./configure --prefix=/tools
  echo "One can safely ignore the error for TestXS_la-TestXS.lo. This is not relevant for LFS and should be ignored."
  read -r -p "Press [Enter] key to resume..."
  make
  read -r -p "Press [Enter] key to resume..."
  make install
  read -r -p "Press [Enter] key to resume..."
)
rm -Rf texinfo-6.7

# xz-5.2.4 || Contains programs for compressing and decompressing files || 0.2 SBUs
tar xvf xz-5.2.4.tar.xz
(
  cd xz-5.2.4 || exit 1
  ./configure --prefix=/tools
  read -r -p "Press [Enter] key to resume..."
  make
  read -r -p "Press [Enter] key to resume..."
  make install
  read -r -p "Press [Enter] key to resume..."
)
rm -Rf xz-5.2.4

# bash strip.sh
cd /home/lfs || exit 1
cp -Rv . $LFS/shdir
su - chroot.sh
