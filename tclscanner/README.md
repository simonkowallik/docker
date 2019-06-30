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

## What is tclscanner
`tclscanner` is a wrapper for `tclscan` written in python 3. It processes many tcl source code files at once, copies them one-by-one to temporary files in the container and reformats them to `tclscan` to work best. Then it generates a report in json format based on the `tclscan` results.

`tclscanner.py` walks a given directory recursively and scans all files, by default this is the current working directory `.`. The `tclscanner` container uses `/scandir` within the container as the default directory, hence it is advised to map your source code repo to `/scandir` (see examples below).

`tclscanner.py` can be limited to specific file extensions, again see below for examples.

## How to use it

Have a look at the help file of tclscanner first:
```sh
docker run --rm -i simonkowallik/tclscanner tclscanner.py --help

...

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

Then run:
```sh
docker run -i --name my_tclscanner simonkowallik/tclscanner COMMAND
```

Once you ran the container successfully, you can save it as a docker image for future use:
```sh
docker commit <container> <my_image_name>
docker commit my_tclscanner my/tclscanner
```

Optionally delete the container:
```sh
docker container rm my_tclscanner
```

For a simple test just run the container in interactive mode (`-i`), this will run tclscanner.py with default options against three test files:
```sh
docker run --rm -i my/tclscanner tclscanner.py | jq .
```
This will produce the following json outout:
```json
{
  "./dangerous.tcl": {
    "errors": [],
    "warnings": [
      "Unquoted expr element:1 code:expr 1 + $one",
      "Unquoted expr element:+ code:expr 1 + $one"
    ],
    "dangerous": [
      "Dangerous unquoted expr element:$one code:expr 1 + $one"
    ]
  },
  "./ok.tcl": {
    "errors": [],
    "warnings": [],
    "dangerous": []
  },
  "./warning.tcl": {
    "errors": [],
    "warnings": [
      "Unquoted expr element:1 code:expr 1 + 1",
      "Unquoted expr element:+ code:expr 1 + 1",
      "Unquoted expr element:1 code:expr 1 + 1"
    ],
    "dangerous": []
  }
}
```

### Run tclscanner against your own tcl code

For example scan all files in directory `$HOME/mytclcode`:
```sh
docker run --rm -i -v $HOME/mytclcode:/scandir:ro my/tclscanner tclscanner.py
```

Scan only files with extensions `tcl` and `txt` in directory `$HOME/mytclcode`:
```sh
docker run --rm -i -v $HOME/mytclcode:/scandir:ro my/tclscanner tclscanner.py --file-extensions tcl txt
```

Limit the scan to a subdirectory of `$HOME/projects`:
```sh
docker run --rm -i -v $HOME/projects:/scandir:ro my/tclscanner tclscanner.py --file-extensions tcl txt --directory ./tclsourcecode
```

## problems / ideas?
If you have any problems or ideas, let me know!
Just open a [github issue](https://github.com/simonkowallik/docker/issues).
