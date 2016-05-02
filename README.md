# RaspberryPi Setup Notes
Various notes on configuring a Pi 3


# Base Image setup

```
https://downloads.raspberrypi.org/raspbian/images/raspbian-2016-02-29/2016-02-26-raspbian-jessie.zip
```

### Auto SSH login setup

on client:

```
HOST=pitv
#if a key doest alreada exists: ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub | ssh pi@$HOST 'mkdir ~/.ssh; cat >> .ssh/authorized_keys'


# All in one line:
if [ -e ~/.ssh/id_rsa.pub ]; then cat ~/.ssh/id_rsa.pub | ssh pi@$HOST 'mkdir ~/.ssh; cat >> .ssh/authorized_keys' ; else ssh-keygen -t rsa; fi; ssh pi@$HOST

```

## raspi-config

```
sudo raspi-config
```

- Expand FS
- Boot to desktop with autologin (helps with x11vnc later)
- Enable serial
- Enable camera
- GPU split 128


## config.txt

```
echo 'dtparam=audio=on
lcd_rotate=2
start_x=1
gpu_mem=128
framebuffer_width=1280
framebuffer_height=720
enable_uart=1' | sudo tee /boot/config.txt

```

Update to last known good version of kernel (e.g. fixes UART)

```
sudo apt-get update
sudo rpi-update 692dde0c1586f7310301379a502b9680d0c104fd
```

**Reboot**


---

# Remote access

The lets you use VNC to access the same Desktop as the one connected to the USB keyboard, mouse and HDMI monitor.

### Install X11 VNC

```
sudo apt-get install x11vnc -y
touch ~/.xsessionrc
mkdir ~/.vnc/
x11vnc -storepasswd letmein /home/pi/.vnc/passwd
echo "x11vnc -bg -nevershared -forever -tightfilexfer -usepw -avahi -display :0" > ~/.xsessionrc
chmod 775 /home/pi/.xsessionrc
```


Apple file shareing
```
sudo apt-get -y install netatalk
```

### NFS Mount

This is for my own dev, you won't deed this.

```
cd ~pi && \
mkdir apps && \
sudo chown root.root apps && \
echo 'slimstation.local:/volume1/rpi/shared/apps /home/pi/apps nfs nouser,atime,auto,rw,dev,exec,suid,nolock,auto 0 0' | sudo tee --append /etc/fstab && \
sudo mount -a
```


### WifI
On Pi:
echo 'network={
ssid=""
psk=""
}' | sudo tee --append /etc/wpa_supplicant/wpa_supplicant.conf 

OR full file:  

ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
network={
ssid=""
psk=""
}


on Mac with SDCard mounted using Paragons EXTFS support 

sudo nano /Volumes/Untitled/etc/wpa_supplicant/wpa_supplicant.conf 







### Bluetooth (Classic) Network sharing

See [Video](https://www.youtube.com/watch?v=4Ac0wc-f9HI)

auto connect:

http://blog.fraggod.net/2015/03/28/bluetooth-pan-network-setup-with-bluez-5x.html


```
sudo apt-get install bluetooth python-gobject blueman --no-install-recommends
sudo usermod -G bluetooth -a $USER
```

---


## Bluetooth LE


### BlueZ
```
sudo apt-get install libglib2.0-dev libdbus-1-dev libical-dev libusb-1.0-0.dev libreadline-dev checkinstall


#For Deb package ref: http://archive.raspbian.org/raspbian/pool/main/b/bluez/
# bluez_5.36-1.debian.tar.xz 
# rules

./configure \
        --libdir=/lib \
        --libexec=/lib \
        --enable-experimental \
	--disable-cups 


sudo systemctl stop bluetooth

#sudo make install
sudo checkinstall

sudo sed -i '/^ExecStart.*bluetoothd\s*$/ s/$/ --experimental/' /lib/systemd/system/bluetooth.service
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


---

# NodeJS


```
sudo apt-get remove -y nodered nodejs nodejs-legacy npm

curl -sL https://deb.nodesource.com/setup_5.x | sudo bash -

sudo apt-get install -y nodejs build-essential python-dev python-rpi.gpio nodejs libudev-dev libusb-1.0-0.dev libcap2-bin

sudo setcap cap_net_raw+eip $(eval readlink -f `which node`)

```

Re-install nodeRed

```
sudo npm cache clean
sudo npm install -g --unsafe-perm  node-red
```

---

# Extras

### Camera Streamining

```
sudo apt-get install -y cmake libjpeg-dev
wget https://github.com/jacksonliam/mjpg-streamer/archive/master.zip
make -j 4

./mjpg_streamer -o "output_http.so -w ./www" -i "input_raspicam.so -fps 24"
```



### Pi Chrome

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


# SysteD Script creation

https://gauntface.com/blog/2015/12/02/start-up-scripts-for-raspbian


