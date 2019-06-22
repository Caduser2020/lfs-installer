#!/bin/bash
sudo yum -y install bison byacc gcc-c++ texinfo
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
python --version
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
sudo fdisk /dev/sda
sudo mke2fs -jv /dev/sda1 
sudo mkswap /dev/sda2 
export LFS=/mnt/lfs 
sudo mkdir -pv $LFS 
sudo mount -v -t ext4 /dev/sda1 $LFS 
sudo /sbin/swapon -v /dev/sda2 
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
# Enter previous password set
sudo -u lfs whoami 
sudo -u lfs cat > ~/.bash_profile << 'EOF' /
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash /
EOF

sudo -u lfs cat > ~/.bashrc << 'EOF' /
set +h /
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/tools/bin:/bin:/usr/bin
export LFS LC_ALL LFS_TGT PATH
EOF
sudo -u lfs cd /mnt/lfs/sources
sudo -u lfs tar xvf binutils-2.32.tar.xz
sudo -u lfs cd binutils-2.32
sudo -u lfs source ~/.bash_profile
sudo -u lfs mkdir -v build; cd build
sudo -u lfs ../configure --prefix=/tools --with-sysroot=$LFS --with-lib-path=/tools/lib --target=$LFS_TGT --disable-nls --disable-werror
sudo -u lfs time make -j2
# real is 1 SBU
sudo -u lfs make install
sudo -u lfs rm -Rf binutils-build
sudo -u lfs rm -Rf binutils-2.32
sudo -u lfs tar xvf gcc-8.2.0.tar.xz
sudo -u lfs cd gcc-8.2.0
sudo -u lfs tar -xf ../mpfr-4.0.2.tar.xz
sudo -u lfs mv -v mpfr-4.0.2 mpfr
sudo -u lfs tar -xf ../gmp-6.1.2.tar.xz
sudo -u lfs mv -v gmp-6.1.2 gmp
sudo -u lfs tar -xf ../mpc-1.1.0.tar.gz
sudo -u lfs mv -v mpc-1.1.0 mpc
sudo -u lfs for file in gcc/config/{linux,i386/linux{,64}}.h \
do \
 cp -uv $file{,.orig} \
 sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
 -e 's@/usr@/tools@g' $file.orig > $file \
 echo ' \
#undef STANDARD_STARTFILE_PREFIX_1 \
#undef STANDARD_STARTFILE_PREFIX_2 \
#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/" \
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file \
 touch $file.orig \
done
sudo -u lfs mkdir -v build
sudo -u lfs cd build
sudo -u lfs ../configure \
 --target=$LFS_TGT \
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
 --disable-libmpx \
 --disable-libquadmath \
 --disable-libssp \
 --disable-libvtv \
 --disable-libstdcxx \
 --enable-languages=c,c++
sudo -u lfs make -j2
sudo -u lfs make install
