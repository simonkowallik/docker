#!/usr/bin/env bash
set -ev

# container started test
docker inspect -f '{{.State.ExitCode}}' httpbin-alpine-ci-tests | grep '^0$' > /dev/null

export containerip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' httpbin-alpine-ci-tests)

curl -si http://${containerip}/anything | grep '^HTTP/1.1 200 OK' > /dev/null