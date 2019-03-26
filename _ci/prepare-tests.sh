#!/bin/bash
# prepare-tests.sh
set -ev
for docker_image in $(git show --format='' --name-only HEAD | cut -d'/' -f1 | uniq)
do
  ./${docker_image}/tests/prepare.sh $docker_image
done