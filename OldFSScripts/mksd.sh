#!/bin/bash

# constants
MB=$(expr 1024 \* 1024)

# User setttomgs
sdcardSizeGB=2
part1_size=$(expr 128 \* $MB)
part2_size='100%'
img=rpi_boot.img

part1FSSource=../boot/base_raspbian/bootfs.sdcard/*
part2FSSource=../boot/current/rootfs/*

# System Settings
loopback=/dev/loop0
part1mount=p1
part2mount=p2


# 
part1_start=512
part2_start=$(expr $part1_start + $part1_size + 512)



########################################################

echo part1_start=$part1_start
echo part1_size=$part1_size
echo part2_start=$part2_start
echo part2_size=$part2_size


# Create the SDCard image on disk
losetup -d $loopback
dd if=/dev/zero of=$img bs=1024M count=0 seek=$sdcardSizeGB
losetup $loopback $img 

# Create the partitions
parted -s $loopback mklabel msdos
parted -s $loopback mkpart primary fat32 ${part1_start}B  ${part1_size}B
parted -s $loopback mkpart primary ext4  ${part2_start}B  ${part2_size}
parted -s $loopback set 1 boot on

parted $loopback unit b print


# Copy files to partition 1
losetup -d $loopback
losetup -o $part1_start --sizelimit $part1_size $loopback $img 
mkfs.vfat -F32 $loopback
mount -t vfat $loopback $part1mount
cp -rf $part1FSSource $part1mount/
umount $loopback
losetup -d $loopback

# Copy files to partition 2
losetup -o $part2_start $loopback $img 
mkfs.ext4 $loopback
mount $loopback $part2mount
cp -frp $part2FSSource $part2mount/
umount $loopback
losetup -d $loopback


# clean

umount $part1mount
umount $part2mount
losetup -d $loopback


exit


#find attaached dvices
#rune before and after inserting SD card, notice change, use the newly apearing device without number suffix
cat /proc/partitions


# inspect device
file -s /dev/sdb1
file -s /dev/sdb2




# write to SD card
# ensure all partitions of SDCArd ar unmounted
umount /dev/sdb1
umount /dev/sdb1


dd bs=1M if=$img of=/dev/sdb


# show dd progress
sudo kill -USR1 `pgrep -l '^dd$' | awk '{print $1}'`






