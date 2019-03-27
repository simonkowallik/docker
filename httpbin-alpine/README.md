# intro
[![](https://images.microbadger.com/badges/image/simonkowallik/httpbin-alpine.svg)](https://microbadger.com/images/simonkowallik/httpbin-alpine)
[![Build Status](https://travis-ci.com/simonkowallik/docker.svg?branch=master)](https://travis-ci.com/simonkowallik/docker)


This docker image implements httpbin on alpine linux.

# What is httpbin
httpbin is a simple HTTP Request & Response Service.

See: [httpbin.org](https://httpbin.org) and [github.com/postmanlabs/httpbin](https://github.com/postmanlabs/httpbin)

# What is alpine
Alpine Linux is a Linux distribution based on musl and BusyBox, primarily designed for security, simplicity, and resource efficiency.
It is very famous and widely used for leightweight docker images.

See: [alpinelinux.org](https://alpinelinux.org) and [alpine on hub.docker.com](https://hub.docker.com/_/alpine)

# What httpbin version is used?
This image is built on the master branch of httpbin, hence always uses the latest code.

# How to use it

    docker run -p 80:80 simonkowallik/httpbin-alpine
