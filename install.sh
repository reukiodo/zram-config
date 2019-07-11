#!/bin/bash

systemctl -q is-active zram-config  && { echo "ERROR: zram-config service is still running. Please run \"sudo service zram-config stop\" to stop it and uninstall"; exit 1; }
[ "$(id -u)" -eq 0 ] || { echo "You need to be ROOT (sudo can be used)"; exit 1; }
[ -d /usr/local/bin/zram-config ] && { echo "zram-config is already installed, uninstall first"; exit 1; }

InstallXattr () {
apt-get install libattr1-dev
git clone https://github.com/kmxz/overlayfs-tools
cd overlayfs-tools
make
cd ..

}

InstallAttr () {
apt-get install libattr1-dev
git clone -b fix_xattr_lib_include https://github.com/Izual750/overlayfs-tools
cd overlayfs-tools
make
cd ..
}


version=$(uname -r)
major=`echo $version | cut -d. -f1`
minor=`echo $version | cut -d. -f2`

if [ "$major" -ge "4" ]
then
        if  [ "$minor" -ge "19" ]
	then
		InstallAttr
	else
		InstallXattr
	fi
else
	InstallXattr
fi



#BRANCH=next rpi-update

# zram-config install 
install -m 755 zram-config /usr/local/bin/
install -m 644 zram-config.service /etc/systemd/system/zram-config.service
install -m 644 ztab /etc/ztab
mkdir -p /usr/local/share/zram-config
mkdir -p /usr/local/share/zram-config/log
install -m 644 uninstall.sh /usr/local/share/zram-config/uninstall.sh
install -m 644 ro-root.sh /usr/local/share/zram-config/ro-root.sh
install -m 644 zram-config.logrotate /etc/logrotate.d/zram-config
mkdir -p /usr/local/lib/zram-config/
install -m 755 overlayfs-tools/overlay /usr/local/lib/zram-config/overlay
systemctl enable zram-config

echo "#####          Reboot to activate zram-config         #####"
echo "#####       edit /etc/ztab to configure options       #####"


