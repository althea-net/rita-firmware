#!/bin/bash
set -eux
cd $(dirname $0)/..
export SERVER=updates
export HTTP_DIR=/usr/share/nginx/html/
ansible-playbook -e @profiles/devices/wrt3200acm.yml -e @profiles/management/althea-managed.yml firmware-build.yml
ansible-playbook -e @profiles/devices/wrt32x.yml -e @profiles/management/althea-managed.yml firmware-build.yml
ansible-playbook -e @profiles/devices/glb1300.yml -e @profiles/management/althea-managed.yml firmware-build.yml
ansible-playbook -e @profiles/devices/ea6350v3.yml -e @profiles/management/althea-managed.yml firmware-build.yml
ansible-playbook -e @profiles/devices/n600.yml -e @profiles/management/althea-managed.yml firmware-build.yml
ansible-playbook -e @profiles/devices/n750.yml -e @profiles/management/althea-managed.yml firmware-build.yml
ansible-playbook -e @profiles/devices/edgerouterx.yml -e @profiles/management/althea-managed.yml firmware-build.yml
ansible-playbook -e @profiles/devices/x86_64.yml -e @profiles/management/althea-managed.yml firmware-build.yml

rsync -ahz --delete build/bin/targets $SERVER:$HTTP_DIR/supported
