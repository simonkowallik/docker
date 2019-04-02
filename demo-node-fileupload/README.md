# demo-node-fileupload
[![Travis Build Status](https://img.shields.io/travis/com/simonkowallik/docker/master.svg?label=travis%20build)](https://travis-ci.com/simonkowallik/docker)
[![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/simonkowallik/demo-node-fileupload.svg?color=brightgreen)](https://hub.docker.com/r/simonkowallik/demo-node-fileupload)
[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/simonkowallik/demo-node-fileupload.svg)](https://hub.docker.com/r/simonkowallik/demo-node-fileupload/builds)
[![image information](https://images.microbadger.com/badges/image/simonkowallik/demo-node-fileupload.svg)](https://microbadger.com/images/simonkowallik/demo-node-fileupload)

## intro
A super simple web app using node to receive multipart/form-data file uploads.

## build docker image

```sh
docker build -t demo-node-fileupload .
```

## run docker container

```sh
docker run --rm -p 8080:80 demo-node-fileupload
```

## upload a file

using curl:

```sh
## curl -XPOST http://<containerip>:8080/upload -F sampleFile=@file.txt
```

response:
```sh
filename:file.txt, mimetype:text/plain, truncated:false, length:2, md5:50585be4e3159a71c874c590d2ba12ec
```
 or point your browser to `http://<containerip>:8080/upload`

## problems / ideas?
If you have any problems or ideas, let me know!
Just open a [github issue](https://github.com/simonkowallik/docker/issues).