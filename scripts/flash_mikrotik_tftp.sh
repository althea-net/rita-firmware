#!/bin/bash
USER=thomas
IFNAME=enp164s0u1u4

IMAGE=2022-01-19-19-58-openwrt-ipq40xx-mikrotik-mikrotik_hap-ac2-initramfs-kernel.bin

#port 67 must be open to receive BOOTP messages
firewall-cmd --add-port=67/udp

#/sbin/ip addr replace 192.168.1.10/24 dev $IFNAME
#/sbin/ip link set dev $IFNAME up

/usr/sbin/dnsmasq --user=$USER \
--no-daemon \
--listen-address 192.168.1.10 \
--bind-interfaces \
-p0 \
--dhcp-authoritative \
--dhcp-range=192.168.1.100,192.168.1.200 \
--bootp-dynamic \
--dhcp-boot=$IMAGE \
--log-dhcp \
--enable-tftp \
--tftp-root=$(pwd)
