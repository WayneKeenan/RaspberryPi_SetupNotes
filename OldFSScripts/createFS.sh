
losetup -d /dev/loop0
losetup -d /dev/loop1
losetup -d /dev/loop2

losetup /dev/loop1 ./rpi_image.img 
losetup -o 8704 /dev/loop2 ./rpi_image.img 


mkfs.vfat -F32 /dev/loop1
mkfs.ext4 /dev/loop2

