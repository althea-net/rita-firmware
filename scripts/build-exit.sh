#!/bin/bash
set -eux
cd $(dirname $0)/..
export SERVER=updates
export HTTP_DIR=/usr/share/nginx/html/

# mvebu
ansible-playbook -e @profiles/devices/wrt3200acm-exit.yml -e @profiles/management/althea-managed.yml firmware-build.yml
ansible-playbook -e @profiles/devices/wrt32x-exit.yml -e @profiles/management/althea-managed.yml firmware-build.yml
ansible-playbook -e @profiles/devices/wrt1900acs-exit.yml -e @profiles/management/althea-managed.yml firmware-build.yml

# ramips
ansible-playbook -e @profiles/devices/edgerouterx-exit.yml -e @profiles/management/althea-managed.yml firmware-build.yml
ansible-playbook -e @profiles/devices/edgerouterx-sfp-exit.yml -e @profiles/management/althea-managed.yml firmware-build.yml

# desktops / servers
ansible-playbook -e @profiles/devices/x86_64-exit.yml -e @profiles/management/althea-managed.yml firmware-build.yml
