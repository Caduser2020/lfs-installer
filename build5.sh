#!/bin/bash  
#=================================================================================== 
# 
# Builds text suite for Linux From Scratch 8.4 on a Red Hat based distribution of linux, such as Fedora, CentOS, or RHEL. 
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

cd /mnt/lfs/sources
if [ $LFS != /mnt/lfs ]
then
    export LFS=/mnt/lfs
else
    echo '\$LFS is set to /mnt/lfs'
fi
if [ -z "$shdir" ]; then echo "\$shdir is blank"; else echo "\$shdir is set to `$shdir`"; fi
echo 'PATH is `pwd`'
read -p "Press [Enter] key to resume..."

# M4-1.4.18 || Contains a macro-processor || 0.2 SBUs
tar xvf m4-1.4.18.tar.xz
cd m4-1.4.18
sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' lib/*.c
echo "#define _IO_IN_BACKUP 0x100" >> lib/stdio-impl.h
./configure --prefix=/tools
read -p "Press [Enter] key to resume..."
make -j4
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /mnt/lfs/sources
rm -Rf m4-1.4.18

# Ncurses-6.1 || Contains  libraries for terminal-independent handling of character screens || 0.6 SBUs
tar xvf ncurses-6.1.tar.gz
cd ncurses-6.1
sed -i s/mawk// configure
./configure --prefix=/tools \
--with-shared \
--without-debug \
--without-ada \
--enable-widec \
--enable-overwrite
read -p "Press [Enter] key to resume..."
make -j4
read -p "Press [Enter] key to resume..."
make install
ln -s libncursesw.so /tools/lib/libncurses.so
read -p "Press [Enter] key to resume..."
cd /mnt/lfs/sources
rm -Rf ncurses-6.1

# Bash-5.0 || Contains Bourne-Again SHell || 0.4 SBUs
tar xvf bash-5.0.tar.gz
cd bash-5.0
./configure --prefix=/tools --without-bash-malloc
read -p "Press [Enter] key to resume..."
make -j4
read -p "Press [Enter] key to resume..."
make install
ln -sv bash /tools/bin/sh
read -p "Press [Enter] key to resume..."
cd /mnt/lfs/sources
rm -Rf bash-5.0

# Bison-3.4.1 || Contains parser generator || 0.3 SBUs
tar xvf bison-3.4.1.tar.xz
cd bison-3.4.1
./configure --prefix=/tools
read -p "Press [Enter] key to resume..."
make
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /mnt/lfs/sources
rm -Rf bison-3.4.1

# Bzip2-1.0.8 || Contains programs for compressing and decompressing files || less than 0.1 SBUs
tar xvf bzip2-1.0.8.tar.gz
cd bzip2-1.0.8
make -j4
read -p "Press [Enter] key to resume..."
make PREFIX=/tools install
read -p "Press [Enter] key to resume..."
cd /mnt/lfs/sources
rm -Rf bzip2-1.0.8

# Coreutils-8.31 || Contains utilities for showing and setting the basic system characteristics || 0.8 SBUs
tar xvf coreutils-8.31.tar.xz
cd coreutils-8.31
./configure --prefix=/tools --enable-install-program=hostname
read -p "Press [Enter] key to resume..."
make -j4
read -p "Press [Enter] key to resume..."
make install 
read -p "Press [Enter] key to resume..."
cd /mnt/lfs/sources
rm -Rf coreutils-8.31

# diffutils-3.7 || Contains programs that show the differences between files or directories || 0.2 SBUs
tar xvf diffutils-3.7.tar.xz
cd diffutils-3.7
./configure --prefix=/tools 
read -p "Press [Enter] key to resume..."
make -j4
read -p "Press [Enter] key to resume..."
make install 
read -p "Press [Enter] key to resume..."
cd /mnt/lfs/sources
rm -Rf diffutils-3.7

# file-5.37 || Contains a utility for determining the type of a given file or files || 0.1 SBUs
tar xvf file-5.37.tar.gz
cd file-5.37
./configure --prefix=/tools 
read -p "Press [Enter] key to resume..."
make -j4
read -p "Press [Enter] key to resume..."
make install 
read -p "Press [Enter] key to resume..."
cd /mnt/lfs/sources
rm -Rf file-5.37

# Findutils-4.6.0 || Contains programs to find files || 0.3 SBUs
tar xvf findutils-4.6.0.tar.gz
cd findutils-4.6.0
sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' gl/lib/*.c
sed -i '/unistd/a #include <sys/sysmacros.h>' gl/lib/mountlist.c
echo "#define _IO_IN_BACKUP 0x100" >> gl/lib/stdio-impl.h
./configure --prefix=/tools 
read -p "Press [Enter] key to resume..."
make -j4
read -p "Press [Enter] key to resume..."
make install 
read -p "Press [Enter] key to resume..."
cd /mnt/lfs/sources
rm -Rf findutils-4.6.0

# Gawk-5.0.1 || Contains programs for manipulating text filess || 0.2 SBUs
tar xvf gawk-5.0.1.tar.xz
cd gawk-5.0.1
./configure --prefix=/tools 
read -p "Press [Enter] key to resume..."
make -j4
read -p "Press [Enter] key to resume..."
make install 
read -p "Press [Enter] key to resume..."
cd /mnt/lfs/sources
rm -Rf gawk-5.0.1

# Gettext-0.20.1 || Contains utilities for internationalization and localization || 1.8 SBUs
tar xvf gettext-0.20.1.tar.xz
cd gettext-0.20.1
./configure --disable-shared
read -p "Press [Enter] key to resume..."
make -j4
read -p "Press [Enter] key to resume..."
cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /tools/bin
read -p "Press [Enter] key to resume..."
cd /mnt/lfs/sources
rm -Rf gettext-0.20.1

# Grep-3.3 || Contains programs for searching through files || 0.2 SBUs
tar xvf grep-3.3.tar.xz
cd grep-3.3
./configure --prefix=/tools
read -p "Press [Enter] key to resume..."
make -j4
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /mnt/lfs/sources
rm -Rf grep-3.3

# Gzip-1.10 || Contains  programs for compressing and decompressing || 0.1 SBUs
tar xvf gzip-1.10.tar.xz
cd gzip-1.10
./configure --prefix=/tools
read -p "Press [Enter] key to resume..."
make -j4
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /mnt/lfs/sources
rm -Rf gzip-1.10

# Make-4.2.1 || Contains a program for compiling packages || 0.1 SBUs
tar xvf make-4.2.1.tar.gz
cd make-4.2.1
sed -i '211,217 d; 219,229 d; 232 d' glob/glob.c
./configure --prefix=/tools --without-guile
read -p "Press [Enter] key to resume..."
make -j4
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /mnt/lfs/sources
rm -Rf make-4.2.1

# Patch-2.7.6 || Contains a program for modifying or creating files by applying a “patch” file typically created by the diff program || 0.2 SBUs
tar xvf patch-2.7.6.tar.xz
cd patch-2.7.6
./configure --prefix=/tools
read -p "Press [Enter] key to resume..."
make -j4
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /mnt/lfs/sources
rm -Rf patch-2.7.6

# Perl-5.30.0 || Contains the Practical Extraction and Report Language || 1.6 SBUs
tar xvf perl-5.30.0.tar.xz
cd perl-5.30.0
sh Configure -des -Dprefix=/tools -Dlibs=-lm -Uloclibpth -Ulocincpth
read -p "Press [Enter] key to resume..."
make -j4
read -p "Press [Enter] key to resume..."
cp -v perl cpan/podlators/scripts/pod2man /tools/bin
mkdir -pv /tools/lib/perl5/5.30.1
cp -Rv lib/* /tools/lib/perl5/5.30.1
read -p "Press [Enter] key to resume..."
cd /mnt/lfs/sources
rm -Rf perl-5.30.1

# Python-3.7.4 || Contains the Python development environment  || 1.4 SBUs
tar xvf Python-3.7.4.tar.xz
cd Python-3.7.4
sed -i '/def add_multiarch_paths/a \        return' setup.py
./configure --prefix=/tools --without-ensurepip
read -p "Press [Enter] key to resume..."
make -j4
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /mnt/lfs/sources
rm -Rf Python-3.7.4

# Sed-4.7 || Contains a stream editor  || 0.2 SBUs
tar xvf sed-4.7.tar.xz
cd sed-4.7
./configure --prefix=/tools
read -p "Press [Enter] key to resume..."
make -j4
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /mnt/lfs/sources
rm -Rf sed-4.7

# tar-1.32 || Contains an archiving program  || 0.3 SBUs
tar xvf tar-1.32.tar.xz
cd tar-1.32
./configure --prefix=/tools
read -p "Press [Enter] key to resume..."
make -j4
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /mnt/lfs/sources
rm -Rf tar-1.32

# texinfo-6.6 || programs for reading, writing, and converting info pages || 0.2 SBUs
tar xvf texinfo-6.6.tar.xz
cd texinfo-6.6
# One can safely ignore the error for TestXS_la-TestXS.lo. This is not relevant for LFS and should be ignored.
./configure --prefix=/tools
read -p "Press [Enter] key to resume..."
make -j4
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /mnt/lfs/sources
rm -Rf texinfo-6.6

# xz-5.2.4 || Contains programs for compressing and decompressing files || 0.2 SBUs
tar xvf xz-5.2.4.tar.xz
cd xz-5.2.4
./configure --prefix=/tools
read -p "Press [Enter] key to resume..."
make -j4
read -p "Press [Enter] key to resume..."
make install
read -p "Press [Enter] key to resume..."
cd /mnt/lfs/sources
rm -Rf xz-5.2.4

# bash strip.sh

su - 
