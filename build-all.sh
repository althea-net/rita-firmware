#!/bin/bash
set -eux
export SERVER=updates
export HTTP_DIR=/usr/share/nginx/html/
export TO_BUILD="edgerouterlite.yml edgerouterx.yml omnia.yml n750.yml"
for config in $TO_BUILD; do
	ansible-playbook -e @profiles/devices/$config -e @profiles/management/althea-dev.yml firmware-build.yml
done


for dir in build/bin/packages/
do
	scp -r $dir $SERVER:$HTTP_DIR
done

for dir in build/bin/targets/
do
	scp -r $dir $SERVER:$HTTP_DIR
done
