#!/usr/bin/env bash
set -ev
for docker_image in $(git show --format='' --name-only HEAD | cut -d'/' -f1 | uniq)
do
  if [[ -d $docker_image ]] && [[ -x ./${docker_image}/tests/run-tests.sh ]]
  then
    ./${docker_image}/tests/run-tests.sh $docker_image
  fi
done