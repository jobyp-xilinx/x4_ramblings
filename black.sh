#!/bin/bash

set -e

SRCS="$@"
[[ -z "$SRCS" ]] && echo "Usage: $0 <PY3_SRC_FILES>" && exit 1

PY3_VENV=/proj/x4_runs/Work/`whoami`/_venv_x4_ramblings
if ! [[ -d $PY3_VENV ]]; then
    make dev-tools
fi

source ${PY3_VENV}/bin/activate
black -t py311 $SRCS

exit 0
