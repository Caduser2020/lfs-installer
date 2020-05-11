#!/bin/bash
#===================================================================================
#
# Builds first part of first toolchain pass for Linux From Scratch 9.1 on a Red Hat based distribution of linux, such as Fedora, CentOS, or RHEL.
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

# Enter previous password set

cd /mnt/lfs/sources || exit 1
whoami | grep -q 'lfs' || { printf "Use 'su - lfs' to run code as the lfs user \
otherwise, it will not continue properly\\n"; exit 1; }

if [ "${LFS}" != /mnt/lfs ]; then
  export LFS=/mnt/lfs
fi

export MAKEFLAGS
MAKEFLAGS="-j $(nproc)"

#Build

# Binutils-2.34 - Pass 1 || Contains a linker, an assembler, and other tools for handling object files || 1 SBUs
tar xvf binutils-2.34.tar.xz
(
  cd binutils-2.34 || exit 1
  target_triplet=$(./config.guess)
  export target_triplet
  echo "Your platform is a $target_triplet"
  read -r -p "Press [Enter] key to resume..."
  mkdir -v build
  (
    cd build || exit 1
    ../configure --prefix=/tools --with-sysroot=$LFS --with-lib-path=/tools/lib --target="$LFS_TGT" --disable-nls --disable-werror
    time make
    echo "Real Time is 1 SBU"
    read -r -p "Press [Enter] key to resume..."
    case $(uname -m) in
    x86_64) mkdir -v /tools/lib && ln -sv lib /tools/lib64 ;;
    esac
    make install
  )
  read -r -p "Press [Enter] key to resume..."
  rm -Rf build
  rm -Rf binutils-2.34
)

# Gcc-9.2.0 - Pass 1 || Contains the GNU compiler collection || 10 SBUs
tar xvf gcc-9.2.0.tar.xz
(
  cd gcc-9.2.0 || exit 1

  ./contrib/download_prerequisites
  for file in gcc/config/{linux,i386/linux{,64}}.h; do
    cp -uv $file{,.orig}
    sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
      -e 's@/usr@/tools@g' $file.orig >$file
    echo '
  #undef STANDARD_STARTFILE_PREFIX_1
  #undef STANDARD_STARTFILE_PREFIX_2
  #define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
  #define STANDARD_STARTFILE_PREFIX_2 ""' >>$file
    touch $file.orig
  done

  case $(uname -m) in
    x86_64)
      sed -e '/m64=/s/lib64/lib/' \
          -i.orig gcc/config/i386/t-linux64
    ;;
  esac

  mkdir -v objdir
  (
    cd objdir || exit 1
    ../configure \
      --target="$LFS_TGT" \
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
      --disable-libquadmath \
      --disable-libssp \
      --disable-libvtv \
      --disable-libstdcxx \
      --enable-languages=c,c++
    read -r -p "Press [Enter] key to resume..."
    make
    read -r -p "Press [Enter] key to resume..."
    make install
    read -r -p "Press [Enter] key to resume..."
  )
  rm -Rf gcc-9.2.0
)
cd /home/lfs || exit 1
bash build2.sh
