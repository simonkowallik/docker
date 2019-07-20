#!/usr/bin/env python3
"""tclscanner.py is a wrapper for tclscan.
It is designed to walk through a directory and scan all files (optionally with specific file extensions only).
It then produces a standard output (currently json) which contains errors, warnings and dangers found.

author: simon kowallik (2019)
github: https://github.com/simonkowallik/docker
"""
import argparse
import json
import os
import re
import subprocess
from shlex import quote as shlex_quote
from tempfile import mkstemp


def multiline_replace(content: str) -> str:
    """multiline_replace deals with more complicated statements which possibly span multiple lines"""
    # fix bad proc formatting
    # see: proc.tcl
    regexp = re.compile(
        r"^\s*proc(\s|\\\n)*([a-zA-Z0-9-_]+)(\s|\\\n)*({([a-zA-Z0-9-_\\\n ]*)}){0,1}(\s|\\\n)*{",
        re.IGNORECASE | re.MULTILINE | re.DOTALL,
    )
    content = regexp.sub(r"proc \2 {\5 args} {", content)

    regexp = re.compile(
        r"^\s*when\s+(\\\n|\s)*(\w+)(\\\n|\s)*(priority|timing|(\d+)|on|off|\\\n|\s)*{",
        re.IGNORECASE | re.MULTILINE | re.DOTALL,
    )
    content = regexp.sub(r"proc \2 {args} {", content)

    # Fix: "badly formed command"
    # See: if.tcl
    regexp = re.compile(
        r"(?<!\\)\n\s*({|else|elseif)",
        re.IGNORECASE,
    )
    content = regexp.sub(r" \1", content)

    return content


def singleline_replace(content: str) -> str:
    """singleline_replace performs simple replacements"""
    content_new: str = ""
    for line in content.splitlines(keepends=False):
        line = line.replace("equals", "eq")
        line = line.replace("starts_with", "eq")
        line = line.replace("ends_with", "eq")
        line = line.replace("contains", "eq")
        line = line.replace("matches_glob", "eq")
        line = line.replace("matches_regex", "eq")
        line = line.replace("call", "")
        line = line.replace("switch", "$switch")
        line = line.replace("static::", "static__")
        line = re.sub(r"^(\s*timing\s+[OoNnFf]{2,3})$", r"set \1", line)
        line = re.sub(r"^(\s*priority\s+\d+)$", r"set \1", line)
        content_new += line
        content_new += "\n"
    return content_new


def checkascii(content: str) -> dict:
    """checkascii expects content as str and checks whether it is ascii (True) or not (False).
    It returns True if content is ascii, False otherwise"""
    try:
        content.encode("ascii")
    except UnicodeEncodeError as error:
        return {"isascii": False, "error": f"{error}"}
    return {"isascii": True, "error": ""}


def create_tmp_file(content: str) -> str:
    """create_tmp_file creates a secure temp file and writes content to it.
    returns filename as str"""
    filedesciptor, filename = mkstemp()
    with open(filedesciptor, "w") as tmpfile:
        tmpfile.write(content)

    return str(filename)


def tclscan(filename: str) -> dict:
    """tclscan executes tclscan in a subprocess.
    It expects filename as str and returns a dict with errors, warnings and dangerous as lists.
    """
    results: dict = {"errors": [], "warnings": [], "dangerous": []}
    result = subprocess.run(
        ["tclscan", "check", shlex_quote(filename)], capture_output=True
    )
    try:
        result.check_returncode()
    except subprocess.CalledProcessError:
        err: str = "ERROR: cannot scan, manual code verification required, error: "
        err += result.stderr.decode("utf8")
        results["errors"].append(err)
        return results

    res = result.stdout.replace(b"\\\n", b"")
    res = res.decode("utf8")
    for line in res.splitlines(False):
        if not line:
            continue
        elif line.startswith("WARNING: message:badly formed command"):
            # badly formed commands stop the scan, hence error instead of warning
            results["errors"].append(line.replace("WARNING: message:", ""))
        elif line.startswith("DANGEROUS:"):
            results["dangerous"].append(line.replace("DANGEROUS: message:", ""))
        elif line.startswith("WARNING:"):
            results["warnings"].append(line.replace("WARNING: message:", ""))
        else:
            results["errors"].append(line[0:1024])

    return results


def convert_tclcode(tclcode: str) -> str:
    """convert_tclcode applies replacements to DSL tclcode for standard tcl interpretation to work. it returns the re-formated code as str.
    """
    tclcode = multiline_replace(tclcode)
    tclcode = singleline_replace(tclcode)
    return tclcode

def run_scan(tclcode: str) -> dict:
    """run_scan expects tclcode as str. It runs several checks and reformats it before running tclscan.
    It returns a dict with all results. Dict contains errors, warnings and dangerous as lists.
    """
    results: dict = {"errors": [], "warnings": [], "dangerous": []}
    tclsresults: dict = {}
    asciicheck: dict = checkascii(tclcode)
    if not asciicheck["isascii"]:
        results["warnings"].append(asciicheck["error"])

    tclcode = convert_tclcode(tclcode=tclcode)

    tmpfile = create_tmp_file(content=tclcode)
    tclsresults = tclscan(tmpfile)
    os.remove(tmpfile)

    results["errors"].extend(tclsresults["errors"])
    results["warnings"].extend(tclsresults["warnings"])
    results["dangerous"].extend(tclsresults["dangerous"])

    return results


def process_directory(directory: str, file_extensions: list) -> dict:
    """process_directory recursively walks directory, copies files to tmpfiles, scans them and returns results as dict str"""
    results: dict = {}
    for dirpath, _, files in os.walk(directory):
        for filename in files:
            if file_extensions:
                extension = filename.split(".")[-1]
                extension = extension.lower()
                if not extension in file_extensions:
                    continue

            fname = os.path.join(dirpath, filename)
            filecontent: str = ""
            results[f"{fname}"] = {"errors": [], "warnings": [], "dangerous": []}
            # read original
            try:
                with open(fname, "rt") as workingfile:
                    filecontent = workingfile.read()
            except UnicodeDecodeError as error:
                results[f"{fname}"]["errors"].append(
                    f"could not read file, error:{error}"
                )
                continue

            results[fname] = run_scan(filecontent)

    return results


def main():
    """main function reads directory argument and runs process_directory. prints results as json to stdout"""
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-d",
        "--directory",
        help="base directory to scan recursively",
        type=str,
        default=".",
    )
    parser.add_argument(
        "-f",
        "--file-extensions",
        nargs="*",
        help="filter for file extensions (case insensitive, default is to scan all files)",
    )
    parser.add_argument(
        "--code-convert-only",
        type=str,
        help="only convert code for the specified file (prints to stdout)",
    )
    args = parser.parse_args()
    if args.code_convert_only:
        try:
            with open(args.code_convert_only, "rt") as workingfile:
                filecontent = workingfile.read()
                print(convert_tclcode(filecontent), end='')
        except UnicodeDecodeError as error:
                print(f"ERROR: could not read file, error:{error}")
        return
    if args.file_extensions is None:
        args.file_extensions = []
    args.file_extensions = [x.lower() for x in args.file_extensions]
    results = process_directory(
        directory=args.directory, file_extensions=args.file_extensions
    )
    result_json = json.dumps(results)
    print(result_json)


if __name__ == "__main__":
    # execute only if run as a script
    main()
