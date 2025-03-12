#!/bin/bash
set -eux
cd $(dirname $0)/..

# desktops / servers
ansible-playbook -e @profiles/exit/x86_64.yml -e @profiles/management/hawk-managed.yml firmware-build.yml

ansible-playbook -e @profiles/exit/mikrotik_hap-ac3.yml -e @profiles/management/hawk-managed.yml firmware-build.yml
ansible-playbook -e @profiles/exit/glb1300.yml -e @profiles/management/hawk-managed.yml firmware-build.yml
ansible-playbook -e @profiles/exit/gl-mt6000.yml -e @profiles/management/hawk-managed.yml firmware-build.yml
