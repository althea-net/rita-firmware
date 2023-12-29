#!/bin/bash
set -eux
cd $(dirname $0)/..
export SERVER=updates
export HTTP_DIR=/usr/share/nginx/html/

# desktops / servers
ansible-playbook -e @profiles/devices/x86_64.yml -e @profiles/management/hawk-managed.yml firmware-build.yml

# rockchip
ansible-playbook -e @profiles/devices/nanopi-r2s.yml -e @profiles/management/hawk-managed.yml firmware-build.yml

# mvebu
ansible-playbook -e @profiles/devices/wrt3200acm.yml -e @profiles/management/hawk-managed.yml firmware-build.yml
ansible-playbook -e @profiles/devices/wrt32x.yml -e @profiles/management/hawk-managed.yml firmware-build.yml
ansible-playbook -e @profiles/devices/wrt1900acs.yml -e @profiles/management/hawk-managed.yml firmware-build.yml

# ipq807x
ansible-playbook -e @profiles/devices/dl-wrtx36.yml -e @profiles/management/hawk-managed.yml firmware-build.yml

# ipq40xx
ansible-playbook -e @profiles/devices/glb1300.yml -e @profiles/management/hawk-managed.yml firmware-build.yml
ansible-playbook -e @profiles/devices/ea6350v3.yml -e @profiles/management/hawk-managed.yml firmware-build.yml
ansible-playbook -e @profiles/devices/mr8300.yml -e @profiles/management/hawk-managed.yml firmware-build.yml
ansible-playbook -e @profiles/devices/ea8300.yml -e @profiles/management/hawk-managed.yml firmware-build.yml
ansible-playbook -e @profiles/devices/mikrotik_hap-ac2.yml -e @profiles/management/hawk-managed.yml firmware-build.yml
ansible-playbook -e @profiles/devices/mikrotik_hap-ac3.yml -e @profiles/management/hawk-managed.yml firmware-build.yml
ansible-playbook -e @profiles/devices/netgear_ex6100v2.yml -e @profiles/management/hawk-managed.yml firmware-build.yml

#broadcom
ansible-playbook -e @profiles/devices/pi4-64.yml -e @profiles/management/hawk-managed.yml firmware-build.yml
