#!/bin/bash
set -ev
# container started test
docker inspect -f '{{.State.ExitCode}}' f5-demo-radius-ci-tests | grep '^0$' > /dev/null

export containerip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' f5-demo-radius-ci-tests)

# incorrect secret test
docker exec -it f5-demo-radius-ci-tests radtest test test $containerip 0 WRONG_SECRET | grep -i 'no reply' > /dev/null

# access-accept test
docker exec -it f5-demo-radius-ci-tests radtest test test $containerip 0 SECRET | grep -i 'received access-accept' > /dev/null

# access-reject test
docker exec -it f5-demo-radius-ci-tests radtest TESTFAIL TESTFAIL $containerip 0 SECRET | grep -i 'received access-reject' > /dev/null

# F5-LTM Roles test
docker exec -it f5-demo-radius-ci-tests radtest viewer viewer $containerip 0 SECRET | grep 'F5-LTM' > /dev/null