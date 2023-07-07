#!/bin/bash
set -eux
cd $(dirname $0)/..
export SERVER=updates
export HTTP_DIR=/usr/share/nginx/html/

# it's probably best to do: `cd build && make dirclean` 

# ipq40xx
ansible-playbook -e @profiles/devices/gl-b2200.yml -e @profiles/management/althea-managed.yml firmware-build.yml

# ipq80xx
#ansible-playbook -e @profiles/devices/netgear_xr500.yml -e @profiles/management/althea-managed.yml firmware-build.yml

#rockchip
#ansible-playbook -e @profiles/devices/linkstar_h68k.yml -e @profiles/management/althea-managed.yml firmware-build.yml



# rsync -ahz --delete build/bin/targets $SERVER:$HTTP_DIR/supported
