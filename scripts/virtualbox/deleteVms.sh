#!/bin/bash
if [ -z "$1" ]
then
	echo "please enter the number of VMs to delete as first argument"
	exit 1
fi


for i in $(seq 1 $1)
do
	vboxmanage controlvm AltheaTest$i poweroff
	sleep 2
	vboxmanage unregistervm AltheaTest$i --delete
	vnet=`vboxmanage list hostonlyifs |sed -n -e 's/^Name:\s*//p' | sort -r| head -n 1`
	vboxmanage dhcpserver remove --ifname $vnet
	vboxmanage hostonlyif remove $vnet
done
