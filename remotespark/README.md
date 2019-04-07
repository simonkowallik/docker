# remotespark
[![Travis Build Status](https://img.shields.io/travis/com/simonkowallik/docker/master.svg?label=travis%20build)](https://travis-ci.com/simonkowallik/docker)
[![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/simonkowallik/remotespark.svg?color=brightgreen)](https://hub.docker.com/r/simonkowallik/remotespark)
[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/simonkowallik/remotespark.svg)](https://hub.docker.com/r/simonkowallik/remotespark/builds)
[![image information](https://images.microbadger.com/badges/image/simonkowallik/remotespark.svg)](https://microbadger.com/images/simonkowallik/remotespark)

## intro
This docker image provides a platform for RemoteSpark's Spark View RDP Gateway in a docker image using alpinelinux and openjdk.
See [RemoteSpark HTML5 Spark View](http://www.remotespark.com/html5.html) for more details about the product.

The RemoteSpark Spark View RDP Gateway software is not shipped within this image, instead it will download and install it automatically when the docker container is first started. This is due to legal/copyright reasons.

However you can build your own docker image and include remotespark right away using the provided `Dockerfile`. See below for more details.

## Docker tags
Each Spark View Version has a tag, which omits the minor version, this is mimicking the behavior of remotespark's habbit of releasing versions.
See [http://www.remotespark.com/view/new.html](http://www.remotespark.com/view/new.html).

current tags:
- `latest`, `5.7` (the latest available version)
- `5.6`
- `5.5`

Please note that the list above might be a bit behind the actual releases, but the most recent docker images and tags should be avialable anyway!

# How to use it

Start the latest version with the default configuration:
```sh
docker run -p 80:80 -p 443:443 simonkowallik/remotespark:latest
```

Start version 5.6 and expose your own `gateway.conf` configuration file to the docker container:
```sh
docker run -p 80:80 -p 443:443 \
    -v $(pwd)/gateway.conf:/usr/local/bin/SparkGateway/gateway.conf \
    simonkowallik/remotespark:5.6
```

An example `docker-compose.yaml` is provided as well for insipiration.

## Build your own image (and optionally embed RemoteSpark's SparkView Software)
Of course you can build your own image using the provided `Dockerfile`.

`docker build` arguments let you control which version of RemoteSpark's Spark View RDP Gateway should be used and whether it should be downloaded immediately and embeded in the docker image.
Make sure to read / understand the product's EULA.

The `Dockerfile` defaults to use the latest available version and to don't embed it into the docker image.
Using the `build-arg` `SPARK_VERSION` and `EMBED` let's you control this behavior.

For example if you want to use version 5.5 and embed it into the docker image you can use:
```sh
docker build --build-arg SPARK_VERSION=5.6 --build-arg EMBED=true .
```
Embedding the latest version can be done with:
```sh
docker build --build-arg EMBED=true .
```

The `docker-compose.yaml` file let's you build the docker image as well.

## a word of warning
This Dockerfile is relying on the release mechanism of RemoteSpark, hence it might break or behave unexpectedly when RemoteSpark decides to change it.

## problems / ideas?
If you have any problems or ideas, let me know!
Just open a [github issue](https://github.com/simonkowallik/docker/issues).