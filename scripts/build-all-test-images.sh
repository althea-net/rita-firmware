#!/bin/bash
set -eux
cd $(dirname $0)/..
export SERVER=updates
export HTTP_DIR=/usr/share/nginx/html/
for file in profiles/devices/* 
do
	ansible-playbook -e @$file -e @profiles/management/althea-test.yml -e gateway=true firmware-build.yml
done

