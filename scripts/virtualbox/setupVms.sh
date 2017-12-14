#!/bin/bash
DIR=$(dirname $0)
diskPath="$DIR/vboxDisks"
imagePath="$DIR/../../build/bin/targets/x86/generic/openwrt-x86-generic-combined-squashfs.vdi"

for i in {1..3}
do
	hostip="192.168.70.$(expr \( $i - 1 \) \* 8 + 1)"
	dhcp="192.168.70.$(expr \( $i - 1 \) \* 8 + 6)"
	guestip="192.168.70.$(expr \( $i - 1 \) \* 8 + 2)"
	vboxmanage clonemedium disk $imagePath $diskPath/testDisk$i.vdi
	vboxmanage createvm --name AltheaTest$i --ostype Linux --register
	vboxmanage hostonlyif create
	#get the latest interface created
	vnet=`vboxmanage list hostonlyifs |sed -n -e 's/^Name:\s*//p' | sort -r| head -n 1`
	#configure interface for a 255.255.255.254 network, even numbers are host, odd are guest
	vboxmanage hostonlyif ipconfig $vnet --ip $hostip --netmask 255.255.255.248
	vboxmanage dhcpserver add --ifname $vnet --ip $dhcp --lowerip $guestip --upperip $guestip --netmask 255.255.255.248 --enable
	vboxmanage modifyvm AltheaTest$i --memory 256 --vram 16 --nic1 hostonly --hostonlyadapter1 $vnet
	vboxmanage storagectl AltheaTest$i --name IDE --add ide
	vboxmanage storageattach AltheaTest$i --storagectl IDE --port 1 --device 1 --type hdd --medium $diskPath/testDisk$i.vdi
done

vboxmanage closemedium $imagePath

vboxmanage modifyvm AltheaTest1 --nic2 intnet --intnet2 althea1
vboxmanage modifyvm AltheaTest2 --nic2 intnet --intnet2 althea1
vboxmanage modifyvm AltheaTest2 --nic3 intnet --intnet3 althea2
vboxmanage modifyvm AltheaTest3 --nic2 intnet --intnet2 althea2

vboxmanage startvm AltheaTest1
vboxmanage startvm AltheaTest2
vboxmanage startvm AltheaTest3

while ! ssh root@192.168.70.2 -n -o "StrictHostKeyChecking no"
do
	echo "trying to connect via ssh"
	sleep 5
done

node1Script="sed -i '31,50d' /etc/config/network"

###Node1###
ssh -o "StrictHostKeyChecking no" root@192.168.70.2 $node1Script

while ! ssh root@192.168.70.10 -n -o "StrictHostKeyChecking no"
do
	echo "trying to connect via ssh"
	sleep 1
done

node2Script="sed -i 's/192\.168\.2\.1/192\.168\.2\.2/' /etc/config/network;\
	sed -i '23s/192\.168\.2\.2/192\.168\.2\.1/' /etc/config/network;\
	sed -i 's/10\.0\.0\.2/10\.0\.0\.3/' /etc/config/network"


###Node2###
ssh -o "StrictHostKeyChecking no" root@192.168.70.10 $node2Script

while ! ssh root@192.168.70.18 -n -o "StrictHostKeyChecking no"
do
	echo "trying to connect via ssh"
	sleep 1
done

node3Script="sed -i 's/192\.168\.2\.1/192\.168\.3\.2/' /etc/config/network;\
	sed -i 's/192\.168\.2\.2/192\.168\.3\.1/' /etc/config/network;\
	sed -i 's/10\.0\.0\.2/10\.0\.0\.5/' /etc/config/network;\
	sed -i '31,50d' /etc/config/network"


##Node3##
ssh -o "StrictHostKeyChecking no" root@192.168.70.18 $node3Script

##Reboot##
ssh -o "StrictHostKeyChecking no" root@192.168.70.2 reboot
ssh -o "StrictHostKeyChecking no" root@192.168.70.10 reboot
ssh -o "StrictHostKeyChecking no" root@192.168.70.18 reboot

