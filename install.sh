# <one line to give the program's name and a brief idea of what it does.>
# Copyright (C) <year>  <name of author>

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

#!/bin/bash
sudo yum -y install bison byacc gcc-c++ patch texinfo
cat > version-check.sh << "EOF"
#!/bin/bash
# Simple script to list version numbers of critical development tools
export LC_ALL=C
bash --version | head -n1 | cut -d" " -f2-4
MYSH=$(readlink -f /bin/sh)
echo "/bin/sh -> $MYSH"
echo $MYSH | grep -q bash || echo "ERROR: /bin/sh does not point to bash"
unset MYSH
echo -n "Binutils: "; ld --version | head -n1 | cut -d" " -f3-
bison --version | head -n1
if [ -h /usr/bin/yacc ]; then
echo "/usr/bin/yacc -> `readlink -f /usr/bin/yacc`";
elif [ -x /usr/bin/yacc ]; then
echo yacc is `/usr/bin/yacc --version | head -n1`
else
echo "yacc not found"
fi
bzip2 --version 2>&1 < /dev/null | head -n1 | cut -d" " -f1,6-
echo -n "Coreutils: "; chown --version | head -n1 | cut -d")" -f2
diff --version | head -n1
find --version | head -n1
gawk --version | head -n1
if [ -h /usr/bin/awk ]; then
echo "/usr/bin/awk -> `readlink -f /usr/bin/awk`";
elif [ -x /usr/bin/awk ]; then
echo awk is `/usr/bin/awk --version | head -n1`
else
echo "awk not found"
fi
gcc --version | head -n1
g++ --version | head -n1
ldd --version | head -n1 | cut -d" " -f2- # glibc version
grep --version | head -n1
gzip --version | head -n1
cat /proc/version
m4 --version | head -n1
make --version | head -n1
patch --version | head -n1
echo Perl `perl -V:version`
python3 --version
sed --version | head -n1
tar --version | head -n1
makeinfo --version | head -n1 # texinfo version
xz --version | head -n1
echo 'int main(){}' > dummy.c && g++ -o dummy dummy.c
if [ -x dummy ]
then echo "g++ compilation OK";
else echo "g++ compilation failed"; fi
rm -f dummy.c dummy
EOF
bash version-check.sh
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
sudo mkdir -pv $LFS 
sudo mount -v -t ext4 /dev/sda1 $LFS 
sudo mkdir -v $LFS/sources 
sudo chmod -v a+wt $LFS/sources 
cd /mnt/lfs/sources 
sudo wget -i ~/Downloads/lfs-installer-lfs-8.4/wget-list.txt -P $LFS/sources
sudo mkdir -v $LFS/tools
sudo ln -sv $LFS/tools /
sudo groupadd lfs
sudo useradd -s /bin/bash -g lfs -m -k /dev/null lfs
# Enter a password for user lfs ?
sudo passwd lfs
sudo chown -v lfs $LFS/tools
sudo chown -v lfs $LFS/sources
cd ~/Downloads/lfs-installer-lfs-8.4
sudo -u lfs bash build.sh
