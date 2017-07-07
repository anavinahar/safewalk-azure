#!/bin/bash
INIT_RAM_MODULES=/etc/initramfs-tools/modules
AZURE_LIST=/etc/apt/sources.list.d/azure.list

ssh root@$1  << EOF
#Install Hyper-V modules
echo "hv_vmbus" >> $INIT_RAM_MODULES
echo "hv_storvsc" >> $INIT_RAM_MODULES
echo "hv_blkvsc" >> $INIT_RAM_MODULES
echo "hv_netvsc" >> $INIT_RAM_MODULES

apt-get install -t jessie-backports hyperv-daemons
update-initramfs -u

#change GRUB settings
sed -i 's|GRUB_CMDLINE_LINUX=.*|GRUB_CMDLINE_LINUX="console=tty0 console=ttyS0,115200 earlyprintk=ttyS0,115200 rootdelay=30"|' /etc/default/grub
update-grub

#update repositories
gpg --keyserver pgpkeys.mit.edu --recv-key  06EA49E9A86CAD7F
gpg -a --export 06EA49E9A86CAD7F | apt-key add -

echo "deb http://debian-archive.trafficmanager.net/debian jessie-backports main" > $AZURE_LIST
echo "deb-src http://debian-archive.trafficmanager.net/debian jessie-backports main" >> $AZURE_LIST
echo "deb http://debian-archive.trafficmanager.net/debian-azure jessie main" >> $AZURE_LIST
echo "deb-src http://debian-archive.trafficmanager.net/debian-azure jessie main" >> $AZURE_LIST
apt-get update

#install sudo
apt-get install -y sudo

#install parted
apt-get install -y parted

#Remove any firewall restriction on port 22
sed -i "/--dport 22/d" /etc/iptables.up.rules

#installing waagent
apt-get install -y waagent
sudo waagent -force -deprovision
export HISTSIZE=0
halt

EOF
