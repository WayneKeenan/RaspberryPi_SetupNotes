losetup -d /dev/loop0
losetup -d /dev/loop1
losetup -d /dev/loop2

rm rpi_image.img

dd if=/dev/zero of=rpi_image.img bs=1024M count=0 seek=2
losetup /dev/loop0 rpi_image.img 

parted -s /dev/loop0  mklabel msdos 
parted -s /dev/loop0 mkpart primary fat32 -- 0 128
parted -s /dev/loop0 mkpart primary ext4 -- 128 -2
parted -s /dev/loop0 set 1 boot on 
fdisk -l /dev/loop0

losetup -d /dev/loop0

losetup /dev/loop1 ./rpi_image.img
mkfs.vfat -F32 /dev/loop1

losetup -o 1008128 /dev/loop2 ./rpi_image.img 
mkfs.ext4 /dev/loop2

mount /dev/loop1 p1
mount /dev/loop2 p2

cp -prf ../boot/current/rootfs/* p2/ 
cp -rf ../boot/base_raspbian/bootfs.sdcard/* p1/


umount p1
umount p2

losetup -d /dev/loop1
losetup -d /dev/loop2


