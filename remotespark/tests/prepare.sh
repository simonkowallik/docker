#!/usr/bin/env bash

cd remotespark

set -v
# kill all other docker containers
docker kill $(docker ps -q) 2> /dev/null

set -ev

for df in $(ls --color=never Dockerfile* | sort -r)
do
  ver=${df/Dockerfile./}
  [[ "$ver" == "Dockerfile" ]] && ver="latest"

# obsolete: handled in Dockerfile
#  if [[ "$ver" == "$(<LATEST_SPARK_VERSION)" ]]
#  then
#    # latest version is not available via /view/${ver}/SparkGateway.zip
#    # therefore skip
#    echo "version:${ver} will be tested as 'latest' - no need to download and test explicitly"
#    continue
#  fi

  docker build -t remotespark-nonembedded:${ver} --build-arg SPARK_VERSION=${ver} --build-arg EMBED=false .
  docker run --rm -d --health-cmd 'curl -f localhost' --name remotespark-nonembedded-${ver} remotespark-nonembedded:${ver}

  docker build -t remotespark-embedded:${ver} --build-arg SPARK_VERSION=${ver} --build-arg EMBED=true .
  docker run --rm -d --health-cmd 'curl -f localhost' --name remotespark-embedded-${ver} remotespark-embedded:${ver}
done