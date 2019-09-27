#!/bin/bash
set -ux
cd $(dirname $0)/..
export SERVER=updates
export HTTP_DIR=/usr/share/nginx/html/
for file in profiles/devices/*
do
	ansible-playbook -e @$file -e @profiles/management/althea-release.yml firmware-build.yml
done

rsync -ahz --delete build/bin/packages $SERVER:$HTTP_DIR/rc/
rsync -ahz --delete build/bin/targets $SERVER:$HTTP_DIR/
