#!/bin/bash
set -ev
docker build -t httpbin-alpine-ci-tests $1
docker run --rm -d -p 8080:80 --name httpbin-alpine-ci-tests httpbin-alpine-ci-tests