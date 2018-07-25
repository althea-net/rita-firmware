#!/bin/bash
set -eux
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOCKER="docker run --rm  firmware-builder "
docker build $DIR -t firmware-builder
$DOCKER /bin/bash -c "cd /home/build && git clone https://github.com/althea-mesh/althea-firmware && cd althea-firmware && ansible-playbook -c localhost -i hosts -e ci=true -e @profiles/devices/$DEVICE.yml -e @profiles/management/althea-release.yml  firmware-build.yml && cd build && make -j16"
