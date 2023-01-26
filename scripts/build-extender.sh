#!/bin/bash
set -eux
cd $(dirname $0)/..

ansible-playbook -e @profiles/devices/mikrotik_hap-ac2-extender.yml -e @profiles/management/althea-managed.yml build-extender.yml
