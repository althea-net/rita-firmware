#!/bin/bash
set -eux
cd $(dirname $0)/..
export SERVER=updates
export HTTP_DIR=/usr/share/nginx/html/


ansible-playbook -e @profiles/devices/wrt3200acm.yml -e @profiles/management/althea-managed.yml -e @profiles/lte/lte.yml -e @profiles/lte/wrt3200acm-lte.yml firmware-build.yml
ansible-playbook -e @profiles/devices/x86_64.yml -e @profiles/management/althea-managed.yml -e @profiles/lte/lte.yml -e @profiles/lte/x86_64-lte.yml firmware-build.yml


# rsync -ahz --delete build/bin/targets $SERVER:$HTTP_DIR/supported
