
```diff
- Attention: The AS3 Schema Validator Tool has been discontinued and replaced with a new solution!
```
See:
[https://github.com/F5Networks/f5-appsvcs-extension/issues/38](https://github.com/F5Networks/f5-appsvcs-extension/issues/38)
[F5 Cloud Docs : Validating a declaration](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/userguide/validate.html#validate)

# intro

The docker images provide a ready made solution to containerize the F5 AS3 Schema Validator.
For further details see: [GitHub : F5Networks/f5-appsvcs-extension : AS3 Schema Validator](https://github.com/F5Networks/f5-appsvcs-extension/tree/master/AS3-schema-validator)

# quickstart guide

run container on port 8000.

    docker run --rm -p 8000:5000 --name f5-as3sv simonkowallik/f5-as3sv:latest

Connect to [http://localhost:8000/](http://localhost:8000/) with your favorite User-Agent.

# docker image

download from docker hub:

    docker pull simonkowallik/f5-as3sv:latest

download a specific version from docker hub:

    docker pull simonkowallik/f5-as3sv:3.5.1
    docker pull simonkowallik/f5-as3sv:3.6.0

To create your own image download this directory and run docker build:

    docker build -t my/f5-as3sv .

# references
For F5 AS3 information check:

[Application Services 3 Extension Documentation](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/)
[GitHub : F5 Application Services 3 Extension (AS3)](https://github.com/F5Networks/f5-appsvcs-extension/)

# problems / ideas?
If you have any problems or ideas, let me know!
Just open a [github issue](https://github.com/simonkowallik/docker/issues).