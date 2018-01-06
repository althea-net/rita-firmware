#!/bin/bash
DIR=$(dirname $0)
diskPath="$DIR/vboxDisks"
imagePath="$DIR/../../build/bin/targets/x86/generic/openwrt-x86-generic-combined-squashfs.vdi"

for i in $(seq 1 $1)
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

