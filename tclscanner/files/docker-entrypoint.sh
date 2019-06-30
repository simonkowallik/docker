#!/usr/bin/env bash
set -Eeo pipefail

if [[ -z $(type -t tclscan) ]]
then
  if [[ "$1" != "build" ]]
  then
    echo; echo "***[DISCLAIMER]***************************************************************************************"; echo
    echo "This container is a wrapper for tclscan, it does not ship with tclscan."
    echo "As the author of tclscan has not added a license to the GitHub repoistory($TCLSCAN_REPO),"
    echo "the terms of use for tclscan are not clear."
    echo
    echo "For more details see: https://github.com/aidanhs/tclscan/issues/2"
    echo
    echo "Please be aware that if you wish to proceed the author of this Docker image is not liable for your actions."
    echo "If you proceed the following will happen:"
    echo "  1. tclscan will be cloned from the repository above"
    echo "  2. tclscan will be patched (patch in: /build/tclscan.patch) and compiled with the rust nightly toolchain"
    echo
    echo "If you understand the above and accept that you are soley resposinble for the following activities"
    echo "run this container with the 'build' command like so:"
    echo
    echo "  docker run -i --name my_tclscanner simonkowallik/tclscanner build"
    echo; echo "******************************************************************************************************"; echo
  fi
fi

if [[ "$1" == "build" ]]
then
  echo -ne "\n\n\n* git clone, patch, compile and install tclscan\n\n\n"
  /compile.sh
else
  exec $@
fi
