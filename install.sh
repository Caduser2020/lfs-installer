#!/bin/bash
#=================================================================================== 
# 
# Installs Linux From Scratch 9.1 on a Red Hat or Debian based distribution of 
# Linux
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
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#=================================================================================== 
# We don't want users to have a non-working install, so we exit on error
set -e

# Set these values so the installer can still run in color
# shellcheck disable=SC2034
COL_NC='\e[0m' # No Color
COL_LIGHT_GREEN='\e[1;32m'
COL_LIGHT_RED='\e[1;31m'
TICK="[${COL_LIGHT_GREEN}✓${COL_NC}]"
CROSS="[${COL_LIGHT_RED}✗${COL_NC}]"
INFO="[i]"

DONE="${COL_LIGHT_GREEN} done!${COL_NC}"
OVER="\\r\\033[K"

is_command() {
  # Checks for existence of string passed in as only function argument.
  # Exit value of 0 when exists, 1 if not exists. Value is the result
  # of the "$(command)" shell built-in call.
  local check_command="$1"

  command -v "${check_command}" >/dev/null 2>&1
}
distro_check() {
  if is_command apt-get ; then 
    PKG_MANAGER="apt-get"
    # A variable to store the command used to update the package cache
    UPDATE_PKG_CACHE="${PKG_MANAGER} update"
    # An array for packages
    PKG_INSTALL=("${PKG_MANAGER}" --yes install)
  elif is_command rpm ; then
    if is_command dnf ; then
      PKG_MANAGER="dnf"
    else
      PKG_MANAGER="yum"
    fi

    if grep -qiE 'centos|scientific' /etc/redhat-release; then
      # We need the PowerTools repo
      PKG_MANAGER=$PKG_MANAGER" --enablerepo=PowerTools "
    fi

    # Fedora based OS update cache on every PKG_INSTALL call, no need for a seperate update.
    UPDATE_PKG_CACHE=":"
    PKG_INSTALL=("${PKG_MANAGER}" install -y)
  else
    printf "OS distribution not supported"
    exit
  fi
}
# Compare multipoint versions
function check_min_version {
  if [[ $1 == "$2" ]]
  then
    printf "%b  %b Checking for %s\\n" "${OVER}" "${TICK}" "$3"
    return 0
  fi
  local IFS="." 
  local ver1 ver2 i
  read -r -a ver1 <<< "$1"
  read -r -a ver2 <<< "$2"
  # local i ver1=($1) ver2=($2)
  # fill empty fields in ver1 with zeros
  for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
  do
    ver1[i]=0
  done
  for ((i=0; i<${#ver1[@]}; i++))
  do
    if [[ -z ${ver2[i]} ]]
    then
      # fill empty fields in ver2 with zeros
      ver2[i]=0
    fi
    if ((10#${ver1[i]} > 10#${ver2[i]}))
    then
      printf "%b  %b Checking for %s\\n" "${OVER}" "${TICK}" "$3"
      return 0
    fi
    if ((10#${ver1[i]} < 10#${ver2[i]}))
    then
      printf "%b  %b Checking for %s (will be installed)\\n" "${OVER}" "${INFO}" "$3"
      installArray+=("$3")
      return 0
    fi
  done
  printf "%b  %b Checking for %s\\n" "${OVER}" "${TICK}" "$3"
  return 0
}
install_deps()
{
  export LC_ALL=C
  # Install packages passed in via argument array
  # No spinner - conflicts with set -e
  declare -a installArray

  local bashversion
  bashversion="$(bash --version | head -n1 | cut -d' ' -f4 | cut -d'(' -f1)"
  check_min_version "$bashversion" '3.2.0' bash
  local MYSH
  MYSH="$(readlink -f /bin/sh)"
  echo "/bin/sh -> $MYSH"
  echo "$MYSH" | grep -q bash || { printf "%bERROR: /bin/sh does not point to bash %b \\n" "${COL_LIGHT_RED}" "${COL_NC}"; installArray+=("bash"); }
  unset MYSH
  
  check_min_version "$(bison --version | head -n1 | cut -d' ' -f4)" '2.7.0' bison
  if [ -h /usr/bin/yacc ]; then
    echo "/usr/bin/yacc -> $(readlink -f /usr/bin/yacc)";
  elif [ -x /usr/bin/yacc ]; then
    echo "yacc is $(/usr/bin/yacc -V | head -n1)"
  else
    echo "yacc not found"; installArray+=("yacc")
  fi
  check_min_version "$(bzip2 --version 2>&1 < /dev/null | head -n1 | cut -d" " -f8 | tr -d ,)" '1.0.4' bzip2
  check_min_version "$(chown --version | head -n1 | cut -d')' -f2 | tr -d ' ')" '6.9.0' coreutils
  check_min_version "$(diff --version | head -n1 | cut -d')' -f2 | tr -d ' ')" '2.8.1' diffutils
  check_min_version "$(find . --version | head -n1 | cut -d')' -f2 | tr -d ' ' | cut -d'.' -f-3)" '4.2.31' findutils
  check_min_version "$(ld --version | head -n1 | awk '{print $(NF)}')" '2.25.0' binutils
  check_min_version "$(gawk --version | head -n1 | cut -d' ' -f3 | tr -d ',')" '4.0.1' gawk
  check_min_version "$(gcc --version | head -n1 | cut -d' ' -f3 | cut -d'-' -f1)" '6.2.0' gcc
  check_min_version "$(g++ --version | head -n1 | cut -d' ' -f3 | cut -d'-' -f1)" '6.2.0' 'g++'
  check_min_version "$(ldd --version | head -n1 | cut -d" " -f2- | cut -d')' -f2 | tr -d ' ')" '2.11' glibc-devel
  check_min_version "$(grep --version | head -n1 | cut -d' ' -f4)" '2.5.1a' grep
  check_min_version "$(gzip --version | head -n1 | cut -d' ' -f2)" '1.3.12' gzip
  check_min_version "$(uname -r)" '3.2.0' linux || printf "%bERROR: Kernel is too old. Upgrade manually. %b \\n" "${COL_LIGHT_RED}" "${COL_NC}";
  check_min_version "$(m4 --version | head -n1 | cut -d' ' -f4)" '1.4.10' m4
  check_min_version "$(make --version | head -n1 | cut -d' ' -f3)" '4.0.0' make
  check_min_version "$(patch --version | head -n1 | cut -d' ' -f3)" '2.5.4' patch
  check_min_version "$(perl -V:version | cut -d"'" -f2)" '5.8.8' perl
  check_min_version "$(python3 --version | cut -d' ' -f2)" '3.4' python3
  check_min_version "$(sed --version | head -n1 | cut -d' ' -f4)" '4.1.5' sed
  check_min_version "$(tar --version | head -n1 | cut -d' ' -f4)" '1.22' tar
  check_min_version "$(makeinfo --version | head -n1 | cut -d' ' -f4)" '4.7' texinfo
  check_min_version "$(xz --version | head -n1 | cut -d' ' -f4)" '5.0' xz
  echo 'int main(){}' > dummy.c && g++ -o dummy dummy.c
  if [ -x dummy ]
    then echo "g++ compilation OK";
    else echo "g++ compilation failed"; exit 1; fi
  rm -f dummy.c dummy

  # Debian based package install - debconf will download the entire package list
  # so we just create an array of packages not currently installed to cut down on the
  # amount of download traffic.
  if is_command debconf-apt-progress ; then
    "${UPDATE_PKG_CACHE[@]}"
    if [[ "${#installArray[@]}" -gt 0 ]]; then
      debconf-apt-progress -- "${PKG_INSTALL[@]}" "${installArray[@]}"
      return
    fi
    printf "\\n"
    return 0
  # Install Fedora/CentOS packages
  elif [[ "${#installArray[@]}" -gt 0 ]]; then
    "${PKG_INSTALL[@]}" "${installArray[@]}" &> /dev/null
    return
  fi
  printf "%b\\n" "${DONE}"
  return 0
}
# Must be root to install
# If the user's id is zero,
if [[ "${EUID}" -eq 0 ]]; then
  # they are root and all is good
  printf "  %b Root user Check\\n" "${TICK}"
# Otherwise,
else
    # They do not have enough privileges, so let the user know
    printf "  %b Root user Check\\n" "${CROSS}"
    printf "  %b %bScript called with non-root privileges%b\\n" "${INFO}" "${COL_LIGHT_RED}" "${COL_NC}"
    printf "      Linux from Scratch requires elevated privileges to install\\n"
    printf "      Please check the installer for any concerns regarding this requirement\\n"
    printf "      Make sure to download this script from a trusted source\\n\\n"
    printf "  %b Sudo utility check" "${INFO}"

    # If the sudo command exists,
    if is_command sudo ; then
        printf "%b  %b Sudo utility check\\n" "${OVER}"  "${TICK}"
        # Download the install script and run it with admin rights
        exec sudo bash install.sh
        exit $?
    # Otherwise,
    else
        # Let them know they need to run it as root
        printf "%b  %b Sudo utility check\\n" "${OVER}" "${CROSS}"
        printf "  %b Sudo is needed for the installer to install LFS\\n\\n" "${INFO}"
        printf "  %b %bPlease re-run this installer as root${COL_NC}\\n" "${INFO}" "${COL_LIGHT_RED}"
        exit 1
    fi
fi
shdir="$(pwd)"
export shdir
distro_check
install_deps
while true
do
  # (1) prompt user, and read command line argument
  read -r -p "Partion the drive? (Answer n unless this is a live cd) " answer

  # (2) handle the input we were given
  case $answer in
   [yY]* ) fdisk /dev/sda
           mke2fs -jv /dev/sda1 
           mkswap /dev/sda2
           /sbin/swapon -v /dev/sda2 
           break;;

   [nN]* ) break;;

   * )     echo "Please enter Y or N.";;
  esac
done 
export LFS=/mnt/lfs 
if test -d '/mnt/lfs/sources';
then
    rm -Rf /mnt/lfs/sources;
    rm -Rf /mnt/lfs/tools;
fi
mkdir -pv $LFS 
mount -v -t ext4 /dev/sda1 $LFS 
mkdir -v $LFS/sources 
chmod -v a+wt $LFS/sources 
cd /mnt/lfs/sources
wget --input-file="$shdir"/wget-list.txt --continue --directory-prefix=$LFS/sources
mv $LFS/e2fsprogs* $LFS/e2fsprogs-1.45.5.tar.gz
mv "$shdir"/md5sums $LFS/sources
pushd $LFS/sources
md5sum -c md5sums
read -r -p "Press [Enter] key to resume..."
popd
mkdir -v $LFS/tools
ln -sv $LFS/tools /
groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs
# Enter a password for user lfs 
passwd lfs
chown -v lfs $LFS/tools
chown -v lfs $LFS/sources
# cd "$shdir" -
chown -R lfs "$shdir"
chmod 777 ./
su - lfs
read -r -p "Press [Enter] key to resume..."
cat > ~/.bash_profile << 'EOF' 
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash 
EOF

cat > ~/.bashrc << 'EOF' 
set +h 
umask 022 
LFS=/mnt/lfs 
LC_ALL=POSIX 
LFS_TGT="$(uname -m)"-lfs-linux-gnu 
PATH=/tools/bin:/bin:/usr/bin 
export LFS LC_ALL LFS_TGT PATH 
EOF

cd ~
# shellcheck disable=SC1091
source .bash_profile