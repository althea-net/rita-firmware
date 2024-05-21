#!/bin/bash
set -eux
cd $(dirname $0)/..
export SERVER=updates
export HTTP_DIR=/usr/share/nginx/html/

rsync -ahz --delete build/bin/packages $SERVER:$HTTP_DIR/rc/
