# RaspberryPi Setup Notes
Various notes on configuring a Pi they way I like


## Remote access

### Install X11 VNC

```
sudo apt-get install x11vnc -y
x11vnc -storepasswd
touch ~/.xsessionrc

echo "x11vnc -bg -nevershared -forever -tightfilexfer -usepw -display :0" >> /home/pi/.xsessionrc

chmod 775 /home/pi/.xsessionrc

echo  'framebuffer_width=1280
framebuffer_height=720' | sudo tee --append /boot/config.txt


```




### Auto SSH login setup

```
on client:
ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub | ssh pi@raspberrypi.local 'mkdir ~/.ssh; cat >> .ssh/authorized_keys'
```


### NFS Mount

```
cd ~pi
mkdir apps
sudo chown root.root apps
echo ‘slimstation.local:/volume1/rpi/shared/apps /home/pi/apps nfs nouser,atime,auto,rw,dev,exec,suid,nolock,auto 0 0' | sudo tee --append /etc/fstab
sudo mount -a
```

### Serial

For Pi 3
```
echo 'enable_uart=1' | sudo tee --append /boot/config.txt
```



## Bluetooth LE


### BlueZ
```
sudo apt-get install libglib2.0-dev libdbus-1-dev libical-dev libusb-1.0-0.dev libreadline-dev checkinstall


#from: http://archive.raspbian.org/raspbian/pool/main/b/bluez/
# bluez_5.36-1.debian.tar.xz 
# rules

./configure \
        --libdir=/lib \
        --libexec=/lib \
        --enable-experimental \
	--disable-cups 

--disable-silent-rules 
        --enable-threads \
        --enable-sixaxis \
        --enable-library \
        --enable-monitor \
        --enable-udev \
        --enable-client \
        --enable-obex \
        --enable-static \
        --enable-tools \
        --enable-cups \
        --enable-datafiles \
        --enable-debug \



sudo systemctl stop bluetooth

#sudo make install
sudo checkinstall
```



```
sudo systemctl daemon-reload 
sudo systemctl restart bluetooth
sudo systemctl status bluetooth
sudo hciconfig hci0 up
```



### bleno


- fixes for  build/install

```
sudo apt-get install libhidapi-dev  ibusb-1.0-0.dev 
cd ~/apps/BLE/noble/examples
node advertisement-discovery.js 
```


# Camera Streamining

```
sudo apt-get install cmake
wget https://github.com/jacksonliam/mjpg-streamer/archive/master.zip
sudo apt-get install cmake libopencv-dev
cd mjpg-streamer-experimental/
make

./mjpg_streamer -o "output_http.so -w ./www" -i "input_raspicam.so -fps 15"
```



# NodeJS


ALTERNATE:  http://thisdavej.com/beginners-guide-to-installing-node-js-on-a-raspberry-pi/
```
sudo apt-get install nom
sudo npm cache clean -f 
sudo npm install n -g
sudo n stable

sudo ln -sf /usr/local/n/versions/node/5.8.0/bin/node /usr/bin/node

Note: wasn't required: sudo ln -sf /usr/local/n/versions/node/5.8.0/bin/npm /usr/bin/npm
```
