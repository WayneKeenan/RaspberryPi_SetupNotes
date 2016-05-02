http://www.root9.net/2012/07/creating-loopback-file-system-image.html


Create 2 GB file 





Create Partition:
-----------------



losetup -d /dev/loop0
rm rpi_image.img
dd if=/dev/zero of=rpi_image.img bs=1024M count=0 seek=2
losetup /dev/loop0 rpi_image.img 


parted -s /dev/loop0 mklabel msdos 
parted -s /dev/loop0 unit cyl mkpart primary fat32 -- 0 16
#parted -s /dev/loop0 unit cyl mkpart primary ext4 -- 0 16
parted -s /dev/loop0 set 1 boot on  
parted -s /dev/loop0 unit cyl mkpart primary ext4 -- 20 -2

#parted -s /dev/loop0 print all

fdisk -l /dev/loop0


Create File Systems:
====================

umount /dev/loop0
umount /dev/loop1
umount /dev/loop2
losetup -d /dev/loop0
losetup -d /dev/loop1
losetup -d /dev/loop2


17 = 8704  (len = 8192)
21 = 20752 (len = 260 - 21 * 512 = 122368)



losetup  /dev/loop1 ./rpi_image.img 
losetup -o 20752   /dev/loop2 ./rpi_image.img 
#--sizelimit 8192
#--sizelimit  122368



mkfs.vfat -F32 /dev/loop1
mkfs.ext4 /dev/loop2


mount -t fat32 /dev/loop1 ./p1
mount /dev/loop2 ./p2


cp -rav ../boot/current/rootfs/* ./p1/
cp -rav ../boot/current/rootfs/* ./p2/






Unmount
-------

umount /dev/loop0
umount /dev/loop1
umount /dev/loop2
losetup -d /dev/loop0
losetup -d /dev/loop1
losetup -d /dev/loop2
