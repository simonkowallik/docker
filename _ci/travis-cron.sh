#!/usr/bin/env bash
set +ev

# only run when TRAVIS_EVENT_TYPE == cron
if [[ "$TRAVIS_EVENT_TYPE" != "cron" ]]
then
  exit 0
fi

# cron jobs
cat ./_ci/dh_tgb | bash
bash ./remotespark/_ci/cron_update_versions.sh
