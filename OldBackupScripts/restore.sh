sudo diskutil unmount /dev/disk1s1
sudo gzip -dc PiRacer2.img.gz | dd of=/dev/disk1
sudo diskutil eject /dev/disk1
