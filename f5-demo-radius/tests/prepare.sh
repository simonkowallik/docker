#!/bin/bash
# prepare.sh
set -ev
docker build -t f5-demo-radius-ci-tests $1
docker run --rm -d -p 1812:1812/udp --name f5-demo-radius-ci-tests f5-demo-radius-ci-tests