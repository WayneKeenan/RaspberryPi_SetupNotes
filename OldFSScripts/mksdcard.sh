sudo umount /dev/sdb1
sudo umount /dev/sdb2
dd bs=4M if=2013-02-09-wheezy-raspbian.img of=/dev/sdb
kill -USR1 <pid>
