#!/bin/bash -x
INIT_RAM_MODULES=/etc/initramfs-tools/modules
AZURE_LIST=/etc/apt/sources.list.d/azure.list
#DEBIAN_DIST=jessie
DEBIAN_DIST=wheezy

#ssh root@$1  << EOF

#Install Hyper-V modules
echo "hv_vmbus" >> $INIT_RAM_MODULES
echo "hv_storvsc" >> $INIT_RAM_MODULES
echo "hv_blkvsc" >> $INIT_RAM_MODULES
echo "hv_netvsc" >> $INIT_RAM_MODULES

#For Debian 7 uncomment this
if [ $DEBIAN_DIST = wheezy ]; then
    apt-get install -f
    echo "deb http://http.debian.net/debian $DEBIAN_DIST-backports main" >> /etc/apt/sources.list.d/sources.list
    apt-get update
fi

apt-get install -t $DEBIAN_DIST-backports hyperv-daemons
update-initramfs -u

#change GRUB settings
sed -i 's|GRUB_CMDLINE_LINUX=.*|GRUB_CMDLINE_LINUX="console=tty0 console=ttyS0,115200 earlyprintk=ttyS0,115200 rootdelay=30"|' /etc/default/grub
update-grub

#update repositories
gpg --keyserver pgpkeys.mit.edu --recv-key  06EA49E9A86CAD7F
gpg -a --export 06EA49E9A86CAD7F | apt-key add -

echo "deb http://debian-archive.trafficmanager.net/debian $DEBIAN_DIST-backports main" > $AZURE_LIST
echo "deb-src http://debian-archive.trafficmanager.net/debian $DEBIAN_DIST-backports main" >> $AZURE_LIST
echo "deb http://debian-archive.trafficmanager.net/debian-azure $DEBIAN_DIST main" >> $AZURE_LIST
echo "deb-src http://debian-archive.trafficmanager.net/debian-azure $DEBIAN_DIST main" >> $AZURE_LIST
apt-get update


#add dns resolution
apt-get install -y dnsmasq

#install parted
apt-get install -y parted

#Remove any firewall restriction on port 22
sed -i "/--dport 22/d" /etc/iptables.up.rules
sed -i "$ i\-A INPUT -p tcp -m tcp --dport 22 -j ACCEPT" /etc/iptables.up.rules
iptables-restore < /etc/iptables.up.rules

#installing waagent
apt-get install -y waagent
sudo waagent -force -deprovision
export HISTSIZE=0
halt

#EOF
