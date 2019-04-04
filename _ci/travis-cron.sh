#!/usr/bin/env bash
set +ev

# only run when TRAVIS_EVENT_TYPE == cron
if [[ "$TRAVIS_EVENT_TYPE" != "cron" ]]
then
  exit 0
fi

# jobs
cat ./_ci/dh_tgb | bash
