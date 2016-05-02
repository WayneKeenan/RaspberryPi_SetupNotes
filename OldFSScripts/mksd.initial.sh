

losetup -d /dev/loop0
dd if=/dev/zero of=rpi_image.img bs=1024M count=0 seek=2
losetup /dev/loop0 rpi_image.img 
parted -s /dev/loop0 mklabel msdos
parted -s /dev/loop0 mkpart primary fat32 0 127
parted -s /dev/loop0 mkpart primary ext4  128 100%
#parted -s /dev/loop0 mkpart primary fat32 16,0,0 1215,3,31
#parted -s /dev/loop0 mkpart primary ext4  128 100%
parted -s /dev/loop0 set 1 boot on








#sfdisk -u -C$cylinders -S$sectors -H$heads /dev/loop0
fdisk -l /dev/loop0


# size limit = part1 end * 512  (= 64s = 1631c  * 512)
losetup -d /dev/loop0
losetup -o 512 --sizelimit 126999552 /dev/loop0 rpi_image.img 
mkfs.vfat -F32 /dev/loop0
mount -t vfat /dev/loop0 p1
cp -rf ../boot/base_raspbian/bootfs.sdcard/* p1/
umount /dev/loop0
losetup -d /dev/loop0

# offset = part2 start * 512  (= 208848 = 1632c * 512)
losetup -o 127926272 /dev/loop0 rpi_image.img 
mkfs.ext4 /dev/loop0
mount /dev/loop0 p2
cp -frp ../boot/current/rootfs/* p2/

#cp -rfp /etc p2/
umount /dev/loop0
losetup -d /dev/loop0



umount p1
umount p2

#find attaached dvices
#rune before and after inserting SD card, notice change, use the newly apearing device without number suffix
cat /proc/partitions


# inspect device
file -s /dev/sdb1

# write to SD card
umount /dev/sdb
dd bs=1M if=rpi_image.img of=/dev/sdb

# show dd progress
sudo kill -USR1 `pgrep -l '^dd$' | awk '{print $1}'`




# clean

umount p1
umount p2
losetup -d /dev/loop0

