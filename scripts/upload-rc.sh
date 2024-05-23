#!/bin/bash
set -eux
cd $(dirname $0)/..
export SERVER=updates
export HTTP_DIR=/usr/share/nginx/html/

# run this after running either build managed or build default release with a package
# signing key in the folder

rsync -ahz --delete build/bin/packages $SERVER:$HTTP_DIR/rc/
