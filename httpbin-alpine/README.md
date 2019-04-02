# httpbin-alpine
[![Travis Build Status](https://img.shields.io/travis/com/simonkowallik/docker/master.svg?label=travis%20build)](https://travis-ci.com/simonkowallik/docker)
[![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/simonkowallik/httpbin-alpine.svg?color=brightgreen)](https://hub.docker.com/r/simonkowallik/httpbin-alpine)
[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/simonkowallik/httpbin-alpine.svg)](https://hub.docker.com/r/simonkowallik/httpbin-alpine/builds)
[![image information](https://images.microbadger.com/badges/image/simonkowallik/httpbin-alpine.svg)](https://microbadger.com/images/simonkowallik/httpbin-alpine)
## intro

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

```sh
docker run -p 80:80 simonkowallik/httpbin-alpine
```

# problems / ideas?
If you have any problems or ideas, let me know!
Just open a [github issue](https://github.com/simonkowallik/docker/issues).