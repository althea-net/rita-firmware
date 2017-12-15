#!/bin/python
import simplejson as json
import sys
import subprocess
import time

with open(sys.argv[1]) as f:
    netTopo = json.load(f)

subprocess.run(["./setupVms.sh", str(len(netTopo["nodes"]))])

lan_config = '''config interface 'lan{ifnum}'
        option type 'bridge'
        option ifname 'eth{ifnum}'
        option proto 'static'
        option ipaddr '192.168.{subnet}.{instance}'
        option netmask '255.255.255.0'
        option ip6assign '60'\n\n'''

tunnel_config = '''config interface mytunnel{ifnum}
	option proto gre
	option tunlink lan{ifnum}
	option zone lan
	option peeraddr 192.168.{subnet}.{instance}\n\n'''

tun_static_config = '''config interface mytunnel{ifnum}_static
	option proto static
	option ifname @mytunnel{ifnum}
	option ipaddr 10.0.0.{address}
	option netmask 255.255.255.254\n\n'''

babel_config_temp = '''config interface\\
        option ifname mytunnel{ifnum}\\
        option hello_interval 4\\
config filter\\
        option type redistribute\\
        option if mytunnel{ifnum}\\
        ## local means only redistribute a /32\\
        option local  true\\
        option action allow\\\n\\\n\\'''

subnets = {}
cur_subnet=2
node_strings = {}

for i in range(len(netTopo["nodes"])):
    ifnum = 1
    i += 1
    node_strings[i] = { "network": "", "babel": "" }
    network_config = ""
    babel_config = ""
#    print("{:#^50}".format(" Node{} ".format(i)))
    for j in netTopo["nodes"][str(i)]:
        if j > i:
            subnets[(i,j)] = cur_subnet
            subnet = cur_subnet
            network_config += lan_config.format(ifnum=ifnum, subnet=cur_subnet, instance=1)
            network_config += tunnel_config.format(ifnum=ifnum, subnet=cur_subnet, instance=2)
            network_config += tun_static_config.format(ifnum=ifnum, address=(cur_subnet-1)*2)
            babel_config += babel_config_temp.format(ifnum=ifnum)
            ifnum += 1
            cur_subnet += 1
        else:
            subnet = subnets[(j,i)]
            network_config += lan_config.format(ifnum=ifnum, subnet=subnet, instance=2)
            network_config += tunnel_config.format(ifnum=ifnum, subnet=subnet, instance=1)
            network_config += tun_static_config.format(ifnum=ifnum, address=(subnet-1)*2+1)
            babel_config += babel_config_temp.format(ifnum=ifnum)
            ifnum += 1
        subprocess.run(["vboxmanage", "modifyvm", "AltheaTest{}".format(i), "--nic{}".format(ifnum+1), "intnet", "--intnet{}".format(ifnum+1), "althea{}".format(subnet)])
        node_strings[i]["babel"] = babel_config
        node_strings[i]["network"] = network_config

    subprocess.run(["vboxmanage", "startvm", "AltheaTest{}".format(i), "--type", "headless"])
    while subprocess.run(["ssh", "-o", "StrictHostKeyChecking no", "root@192.168.70.{}".format((i-1)*8+2), "echo '{}' >>/etc/config/network; sed -i '15a {}' /etc/config/babeld;reboot".format(network_config, babel_config)]).returncode != 0:
        time.sleep(5)
print("success!")
