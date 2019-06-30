# tclscanner
[![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/simonkowallik/tclscanner.svg?color=brightgreen)](https://hub.docker.com/r/simonkowallik/tclscanner)
[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/simonkowallik/tclscanner.svg)](https://hub.docker.com/r/simonkowallik/tclscanner/builds)
[![image information](https://images.microbadger.com/badges/image/simonkowallik/tclscanner.svg)](https://microbadger.com/images/simonkowallik/tclscanner)
## intro

This docker image implements a wrapper around [tclscan](https://github.com/aidanhs/tclscan).
As `tclscan` has no LICENSE, this container does not ship with `tclscan` binaries or code. See [this issue](https://github.com/aidanhs/tclscan/issues/2) for details about the license problem.
What it does is:

- It helps you compile `tclscan` with the latest rust lang release
- It provides assistance with scanning lots of tcl files


## What is tclscan
tclscan is a tool written in rust lang to scan tcl code for [potentially dangerous double substitution](https://wiki.tcl-lang.org/page/double+substitution) issues.

See: [tclscan](https://github.com/aidanhs/tclscan) and [wiki.tcl-lang.org/page/double+substitution](https://wiki.tcl-lang.org/page/double+substitution)

## How to use it

Run:
```sh
docker run -i --name my_tclscanner -v /path/to/tcl/source/files:/scandir:ro simonkowallik/tclscanner
```

The above command starts the container interactively and will provide you with further instructions (and a disclaimer) on how to run it.

`-v /path/to/tcl/source/files:/scandir:ro` maps your local directory `/path/to/tcl/source/files` to `/scandir` within the container. `:ro` instructs it to mount it read-only for additional safety (even though files will not be modified).

Once you started the container successfully, you can also save it as a docker image for future use:
```sh
docker commit <container> <my_image_name>
docker commit my_tclscanner my/tclscanner
```

You can invoke `tclscanner.py` directly with:
```sh
docker run --rm -i my/tclscanner tclscanner.py --help
usage: tclscanner.py [-h] [-d DIRECTORY]
                     [-f [FILE_EXTENSIONS [FILE_EXTENSIONS ...]]]
                     [--code-convert-only CODE_CONVERT_ONLY]

optional arguments:
  -h, --help            show this help message and exit
  -d DIRECTORY, --directory DIRECTORY
                        base directory to scan recursively
  -f [FILE_EXTENSIONS [FILE_EXTENSIONS ...]], --file-extensions [FILE_EXTENSIONS [FILE_EXTENSIONS ...]]
                        filter for file extensions (case insensitive, default
                        is to scan all files)
  --code-convert-only CODE_CONVERT_ONLY
                        only convert code for the specified file (prints to
                        stdout)
```

For example scan all files with extensions `tcl` and `txt` in directory `$HOME/mytclcode`:
```sh
docker run --rm -i -v $HOME/mytclcode:/scandir:ro my/tclscanner tclscanner.py --directory /scandir --file-extensions tcl txt
```

## problems / ideas?
If you have any problems or ideas, let me know!
Just open a [github issue](https://github.com/simonkowallik/docker/issues).
