# RaspberryPi Setup Notes
Various notes on configuring a Pi 3


# Base Image setup

```
https://downloads.raspberrypi.org/raspbian/images/raspbian-2016-02-29/2016-02-26-raspbian-jessie.zip
```

## raspi-config

- Expand FS

**Reboot**


Choose last known good version of kernel (e.g. fixes UART)

```
sudo rpi-update 692dde0c1586f7310301379a502b9680d0c104fd
```


**Reboot**

## Remote access


### Auto SSH login setup

on client:

```
#if a key doest alreada exists: ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub | ssh pi@raspberrypi.local 'mkdir ~/.ssh; cat >> .ssh/authorized_keys'


# All in one line:
if [ -e ~/.ssh/id_rsa.pub ]; then cat ~/.ssh/id_rsa.pub | ssh pi@raspberrypi.local 'mkdir ~/.ssh; cat >> .ssh/authorized_keys' ; else ssh-keygen -t rsa; fi

```

# config.txt

```
echo 'dtparam=audio=on
start_x=1
gpu_mem=128
framebuffer_width=1280
framebuffer_height=720
enable_uart=1' | sudo tee /boot/config.txt
```




### Install X11 VNC

```
sudo apt-get install x11vnc -y
x11vnc -storepasswd letmein /home/pi/.vnc/passwd
touch ~/.xsessionrc
echo "x11vnc -bg -nevershared -forever -tightfilexfer -usepw -avahi -displayinet :0" >> /home/pi/.xsessionrc
chmod 775 /home/pi/.xsessionrc

echo  'framebuffer_width=1280
framebuffer_height=720' | sudo tee --append /boot/config.txt


```



### NFS Mount

```
cd ~pi && \
mkdir apps && \
sudo chown root.root apps && \
echo ‘slimstation.local:/volume1/rpi/shared/apps /home/pi/apps nfs nouser,atime,auto,rw,dev,exec,suid,nolock,auto 0 0' | sudo tee --append /etc/fstab && \
sudo mount -a
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

sudo sed -i '/^ExecStart.*bluetoothd\s*$/ s/$/ --experimental/' /lib/systemd/system/bluetooth.service
#sudo sed -i '/^ExecStart.*bluetoothd\s*$/ s/$/ --experimental/' /etc/systemd/system/bluetooth.target.wants/bluetooth.service
#sudo sed -i '/^ExecStart/ s/usr\/bin/usr\/local\/bin/' /lib/systemd/system/hciuart.service

sudo systemctl daemon-reload && sudo systemctl restart bluetooth && sudo systemctl status bluetooth

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


# Pi Chrome

```
Pi Chromium

http://askubuntu.com/questions/225930/how-do-i-get-the-latest-beta-and-development-version-of-chromium


LATEST BUILDS:  https://launchpad.net/~saiarcot895/+archive/ubuntu/chromium-beta/+builds?build_text=&build_state=all

50

https://launchpad.net/~saiarcot895/+archive/ubuntu/chromium-beta/+packages


Stable:
https://launchpad.net/ubuntu/trusty/armhf/libgcrypt11/
https://launchpad.net/ubuntu/trusty/armhf/chromium-browser/
https://launchpad.net/ubuntu/trusty/armhf/chromium-codecs-ffmpeg-extra/

wget http://launchpadlibrarian.net/237755896/libgcrypt11_1.5.3-2ubuntu4.3_armhf.deb
wget http://launchpadlibrarian.net/248437551/chromium-codecs-ffmpeg-extra_49.0.2623.87-0ubuntu0.14.04.1.1112_armhf.deb
wget http://launchpadlibrarian.net/248437549/chromium-browser_49.0.2623.87-0ubuntu0.14.04.1.1112_armhf.deb

```


# Debian Package Creation

https://sourceforge.net/p/raspberry-gpio-python/code/ci/default/tree/

