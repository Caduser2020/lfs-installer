#!/bin/bash
#===================================================================================
#
# Builds test suite for Linux From Scratch 9.1 on a Red Hat based distribution of linux, such as Fedora, CentOS, or RHEL.
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

export LFS=/mnt/lfs

# Tcl-8.6.10 || Contains the Tool Command Language; Minimal Install || 0.9 SBUs
# NOTE:
tar xvf tcl8.6.10-src.tar.gz
(
  cd tcl8.6.10/unix || exit 1
  ./configure --prefix=/tools
  read -r -p "Press [Enter] key to resume..."
  make
  read -r -p "Press [Enter] key to resume..."
  # As this test may fail under certain host conditions, this test may be removed in a future version of LFS-installer.
  # TZ=UTC make test
  # read -r -p "Press [Enter] key to resume..."
  make install
  read -r -p "Press [Enter] key to resume..."
  chmod -v u+w /tools/lib/libtcl8.6.so
  make install-private-headers
  ln -sv tclsh8.6 /tools/bin/tclsh
  read -r -p "Press [Enter] key to resume..."
)
rm -Rf tcl8.6.10

# Expect5.45.4 || Contains a program for carrying out scripted dialogues with other interactive programs || 0.1 SBUs
tar xvf expect5.45.4.tar.gz
(
  cd expect5.45.4 || exit 1
  cp -v configure{,.orig}
  sed 's:/usr/local/bin:/bin:' configure.orig >configure
  read -r -p "Press [Enter] key to resume..."
  ./configure --prefix=/tools \
    --with-tcl=/tools/lib \
    --with-tclinclude=/tools/include
  read -r -p "Press [Enter] key to resume..."
  make
  read -r -p "Press [Enter] key to resume..."
  # make test
  # read -r -p "Press [Enter] key to resume..."
  make SCRIPTS="" install
  read -r -p "Press [Enter] key to resume..."
)
rm -Rf expect5.45.4

# Dejagnu-1.6.2 || Contains a framework for testing other programs || less than 0.1 SBUs
tar xvf dejagnu-1.6.2.tar.gz
(
  cd dejagnu-1.6.2 || exit 1
  ./configure --prefix=/tools
  read -r -p "Press [Enter] key to resume..."
  make install
  read -r -p "Press [Enter] key to resume..."
  # Test results
  make check
  read -r -p "Press [Enter] key to resume..."
)
rm -Rf dejagnu-1.6.2

bash /home/lfs/build5.sh
