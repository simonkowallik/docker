#!/usr/bin/env bash
set -ev

# container started test
docker inspect -f '{{.State.ExitCode}}' httpbin-alpine-ci-tests | grep '^0$' > /dev/null

# run httpbin test suite within container
docker exec -it httpbin-alpine-ci-tests python3 /httpbin/test_httpbin.py

# query container via curl
curl -si http://localhost:8000/get | grep '^HTTP/1.1 200 OK' > /dev/null
curl -s -XPOST -d 'test=success' http://localhost:8000/anything/post | jq '.form.test' | grep '^"success"$'
