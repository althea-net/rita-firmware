#!/bin/bash
set -eux
cd $(dirname $0)/..
export SERVER=updates
export HTTP_DIR=/usr/share/nginx/html/

# ramips
ansible-playbook -e @profiles/devices/cudy_wr2100.yml -e @profiles/management/althea-managed.yml firmware-build.yml
ansible-playbook -e @profiles/devices/mikrotik_routerboard-750gr3.yml -e @profiles/management/althea-managed.yml firmware-build.yml

# rockchip
ansible-playbook -e @profiles/devices/nanopi-r2s.yml -e @profiles/management/althea-managed.yml firmware-build.yml

# mvebu

# ipq40xx
ansible-playbook -e @profiles/devices/mikrotik_hap-ac2.yml -e @profiles/management/althea-managed.yml firmware-build.yml


# rsync -ahz --delete build/bin/targets $SERVER:$HTTP_DIR/supported
