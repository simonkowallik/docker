#!/usr/bin/env bash
set -Eeo pipefail

if [[ "$NOLICENSE_ACCEPT" -ne "1" ]]
then
  echo; echo "******************************************************************************************************"; echo
  echo "This container is a wrapper for tclscan."
  echo "The author of tclscan has not added a license to the GitHub repoistory($TCLSCAN_REPO),"
  echo "therefore the terms of use for tclscan are not clear."
  echo "For more details see: https://github.com/aidanhs/tclscan/issues/2"
  echo "Please be aware that if you wish to proceed the author of this Docker image is not liable for your actions."
  echo "If you proceed the following will happen:"
  echo "  1. tclscan will be cloned from the repository above"
  echo "  2. tclscan will be patched (patch: /build/tclscan.patch) and compiled with the rust nightly toolchain"
  echo
  echo "If you understand the above and accept that you are soley resposinble for the following activities"
  echo "set the environment variable NOLICENSE_ACCEPT=1 when launching this container."
  echo "(use: docker run ... -e VAR=value ...)"
  echo; echo "******************************************************************************************************"; echo
  exit 1
fi

if [[ -z $(type -t tclscan) ]]
then
  echo -ne "\n\n\n* tclscan not installed: patch & compile & install tclscan\n\n\n"
  /compile.sh
fi

exec $@
