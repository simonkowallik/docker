#!/usr/bin/env bash
set -ev

for df in $(ls --color=never Dockerfile* | sort -r)
do
  ver=${df/Dockerfile./}
  [[ "$ver" == "Dockerfile" ]] && ver="latest"

  # check if the container build proccess produced running containers
  docker ps --format '{{.Names}}' | grep "remotespark-nonembedded-${ver}" || exit 1
  docker ps --format '{{.Names}}' | grep "remotespark-embedded-${ver}" || exit 1
done

# overview
docker ps --format 'table {{.Names}}\t{{.Status}}'

countdown=180 # 15 min
while [[ "$(docker ps --format '{{.Names}}\t{{.Status}}' | grep remotespark | grep -v '(healthy)' | wc -l)" != "0" ]]
do
  sleep 5
  countdown=$(($countdown - 1))

  docker ps --format 'table {{.Names}}\t{{.Status}}' | grep remotespark | grep -v '(healthy)'

  # countdown reached above docker container didn't become healthy in time
  [[ "$countdown" == "0" ]] && exit 1
done || true