#!/bin/bash
for i in {1..3}
do
	vboxmanage controlvm AltheaTest$i poweroff
	sleep 2
	vboxmanage unregistervm AltheaTest$i --delete
	vnet=`vboxmanage list hostonlyifs |sed -n -e 's/^Name:\s*//p' | sort -r| head -n 1`
	vboxmanage dhcpserver remove --ifname $vnet
	vboxmanage hostonlyif remove $vnet
done
