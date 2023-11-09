#!/usr/bin/env python3.11

import argparse
import logging
import os
import sys
import subprocess
import shlex
import itertools


COUNTER = itertools.count(1)


def log(msg, use_print=False):
    log_fn = print if use_print else logging.info
    log_fn(msg)
    return


def merge_two_fsdbs(f1, f2):
    count = next(COUNTER)
    m = f"merged_{count}.fsdb"
    print(f"fsdbmerge {f1} {f2} -o {m}")
    print(f"echo `date` -- `ls -lh {m}` >> ../timestamp.log")
    for f in (f1, f2):
        if f.startswith("merged_"):
            print(f"rm -v {f}")
    return m


def merge_fsdbs(lst):
    length = len(lst)
    assert length > 0
    if length == 1:
        return lst[0]
    if length == 2:
        return merge_two_fsdbs(lst[0], lst[1])
    assert length > 2
    mid = length // 2
    left, right = lst[:mid], lst[mid:]
    f1 = merge_fsdbs(left)
    f2 = merge_fsdbs(right)
    return merge_two_fsdbs(f1, f2)


def do_cmd(cmd, capture_output=True):
    c = subprocess.run(cmd, capture_output=capture_output)
    if c.stdout is not None:
        out = c.stdout.decode("utf-8").strip()
    else:
        out = ""
    if c.stderr is not None:
        err = c.stderr.decode("utf-8").strip()
    else:
        err = ""
    return (c.returncode, out, err)


def main(args):
    if args.fsdb_dir == "":
        log(
            "Cannot proceed without directory containing FSDB files to be merged. See help."
        )
        sys.exit(1)
    ret, fsdb_dir, _ = do_cmd(["bash", "-c", f"cd {args.fsdb_dir}; realpath ."])
    if ret != 0 or fsdb_dir == "":
        log("Cannot proceed without a valid directory containing FSDB files")
        sys.exit(1)
    ret, file_list, _ = do_cmd(
        [
            "bash",
            "-c",
            f"cd {fsdb_dir}; ls -1 --color=no | grep -E '[0-9]+_[0-9]+\.fsdb'",
        ]
    )
    print(
        f"""#!/bin/bash

source /proj/verif_release_ro/cbwa_initscript/current/cbwa_init.bash
module load verdi/2023.03-SP2-1


set -ex

pushd {fsdb_dir}
: > ../timestamp.log

"""
    )
    lines = file_list.splitlines()
    if len(lines) > 0:
        m = merge_fsdbs(lines)
        print(f"cp -v {m} final.fsdb")
        print(f"rm -v {m}")
    print("popd")
    print("exit 0")
    # f_list = " ".join(lines[:3])
    # print(f"cd E2W.fsdbdir; fsdbmerge {f_list} -o ../merged_tmp.fsdb")
    # print("cd ..")
    # a = 3
    # b = 20
    # while b < len(lines) + 10:
    #     lst = lines[a:b]
    #     f_list = " ".join(lst)
    #     print("cd E2W.fsdbdir")
    #     print(f"fsdbmerge ../merged_tmp.fsdb {f_list} -o ../merged.fsdb;")
    #     print("cd ..")
    #     print("rm -vf merged_tmp.fsdb; cp -v merged.fsdb merged_tmp.fsdb")
    #     print("sleep 10s")
    #     a, b = b, b + 20
    return


if __name__ == "__main__":
    logging.basicConfig(
        stream=sys.stderr,
        level=logging.INFO,
        filemode="a",
        format="%(asctime)s:%(levelname)s:%(message)s",
    )

    parser = argparse.ArgumentParser(
        prog=sys.argv[0],
        description="Script to merge FSDB files using fsdbmerge command.",
    )
    parser.add_argument(
        "--fsdb-dir",
        type=str,
        default="",
        help="directory containing FSDB files to be merged",
    )
    # parser.add_argument(
    #     "--threads",
    #     type=int,
    #     default=1,
    #     help="Number of FSDB threads (LSF jobs) to be run in parallel",
    # )
    args = parser.parse_args()
    main(args)
    sys.exit(0)
