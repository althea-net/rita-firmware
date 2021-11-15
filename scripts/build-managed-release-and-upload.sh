#!/bin/bash
set -eux
cd $(dirname $0)/..
export SERVER=updates
export HTTP_DIR=/usr/share/nginx/html/

# ramips
ansible-playbook -e @profiles/devices/edgerouterx.yml -e @profiles/management/althea-managed.yml firmware-build.yml
ansible-playbook -e @profiles/devices/edgerouterx-sfp.yml -e @profiles/management/althea-managed.yml firmware-build.yml
ansible-playbook -e @profiles/devices/tplinka6v3.yml -e @profiles/management/althea-managed.yml firmware-build.yml
ansible-playbook -e @profiles/devices/cudy_wr2100.yml -e @profiles/management/althea-managed.yml firmware-build.yml
ansible-playbook -e @profiles/devices/ea7300v2.yml -e @profiles/management/althea-managed.yml firmware-build.yml
ansible-playbook -e @profiles/devices/ea7300v1.yml -e @profiles/management/althea-managed.yml firmware-build.yml
ansible-playbook -e @profiles/devices/ea7500v2.yml -e @profiles/management/althea-managed.yml firmware-build.yml

# desktops / servers
ansible-playbook -e @profiles/devices/x86_64.yml -e @profiles/management/althea-managed.yml firmware-build.yml

# rockchip
ansible-playbook -e @profiles/devices/nanopi-r2s.yml -e @profiles/management/althea-managed.yml firmware-build.yml

# mvebu
ansible-playbook -e @profiles/devices/wrt3200acm.yml -e @profiles/management/althea-managed.yml firmware-build.yml
ansible-playbook -e @profiles/devices/wrt32x.yml -e @profiles/management/althea-managed.yml firmware-build.yml
ansible-playbook -e @profiles/devices/wrt1900acs.yml -e @profiles/management/althea-managed.yml firmware-build.yml

# ipq40xx
ansible-playbook -e @profiles/devices/glb1300.yml -e @profiles/management/althea-managed.yml firmware-build.yml
ansible-playbook -e @profiles/devices/ea6350v3.yml -e @profiles/management/althea-managed.yml firmware-build.yml
ansible-playbook -e @profiles/devices/mr8300.yml -e @profiles/management/althea-managed.yml firmware-build.yml

# ath79
ansible-playbook -e @profiles/devices/n750.yml -e @profiles/management/althea-managed.yml firmware-build.yml

rsync -ahz --delete build/bin/targets $SERVER:$HTTP_DIR/supported
