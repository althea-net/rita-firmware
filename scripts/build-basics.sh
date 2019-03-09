#!/bin/bash
set -eux
ansible-playbook -e @profiles/devices/glb1300.yml -e @profiles/management/althea-test.yml build-and-upgrade.yml  
ansible-playbook -e @profiles/devices/n600.yml -e @profiles/management/althea-test.yml firmware-build.yml
ansible-playbook -e @profiles/devices/n750.yml -e @profiles/management/althea-test.yml firmware-build.yml
ansible-playbook -e @profiles/devices/x86_64.yml -e @profiles/management/althea-test.yml firmware-build.yml
ansible-playbook -e @profiles/devices/edgerouterx.yml -e @profiles/management/althea-test.yml firmware-build.yml
