losetup -d /dev/loop0
rm rpi_image.img
dd if=/dev/zero of=rpi_image.img bs=1024M count=0 seek=2
losetup /dev/loop0 rpi_image.img 


parted -s /dev/loop0 mklabel msdos 
parted -s /dev/loop0 unit cyl mkpart primary fat32 -- 0 16
parted -s /dev/loop0 set 1 boot on  
parted -s /dev/loop0 unit cyl mkpart primary ext4 -- 20 -2

#parted -s /dev/loop0 print all

fdisk -l /dev/loop0

