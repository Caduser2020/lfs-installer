#!/bin/bash  
#=================================================================================== 
# 
# Boot into the new LFS installation
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
LFS=/mnt/lfs
export LFS

umount -lv $LFS/dev/pts
umount -lv $LFS/dev
umount -lv $LFS/run
umount -lv $LFS/proc
umount -lv $LFS/sys
umount -lv $LFS
read -r -p "Press [Enter] key to resume..."
shutdown -r now