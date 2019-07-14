#!/bin/bash
#=================================================================================== 
# 
# Installs Linux From Scratch 8.4 on a Red Hat based distribution of linux, such as Fedora, CentOS, or RHEL.
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
sudo yum -y update
sudo yum -y install bison byacc gcc-c++ patch texinfo
_script="$(readlink -f ${BASH_SOURCE[0]})"
shdir="$(dirname $_script)"
export shdir
if [ $shdir != "$(dirname $_script)" ]
then
  exit
fi
read -p "Press [Enter] key to resume..."
sudo bash version-check.sh
while true
do
  # (1) prompt user, and read command line argument
  read -p "Partion the drive? (Answer n unless this is a live cd) " answer

  # (2) handle the input we were given
  case $answer in
   [yY]* ) sudo fdisk /dev/sda
           sudo mke2fs -jv /dev/sda1 
           sudo mkswap /dev/sda2
           sudo /sbin/swapon -v /dev/sda2 
           break;;

   [nN]* ) break;;

   * )     echo "Dude, just enter Y or N, please.";;
  esac
done 
export LFS=/mnt/lfs 
if test -d '/mnt/lfs/sources';
then
    sudo rm -Rf /mnt/lfs/sources;
    sudo rm -Rf /mnt/lfs/tools;
fi
sudo mkdir -pv $LFS 
sudo mount -v -t ext4 /dev/sda1 $LFS 
sudo mkdir -v $LFS/sources 
sudo chmod -v a+wt $LFS/sources 
cd /mnt/lfs/sources
sudo wget -i $shdir/wget-list.txt -P $LFS/sources
mv $shdir/md5sums $LFS/sources
pushd $LFS/sources
md5sum -c md5sums
read -p "Press [Enter] key to resume..."
popd
sudo mkdir -v $LFS/tools
sudo ln -sv $LFS/tools /
sudo groupadd lfs
sudo useradd -s /bin/bash -g lfs -m -k /dev/null lfs
# Enter a password for user lfs ?
sudo passwd lfs
sudo chown -v lfs $LFS/tools
sudo chown -v lfs $LFS/sources
# cd $shdir
sudo chown -v lfs $shdir
sudo chmod 777 ./
sudo -u lfs bash $shdir/build.sh