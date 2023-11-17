#!/bin/bash

set -e

QUEUE="$1"
[[ -z "$QUEUE" ]] && echo "$0  <QUEUE>" && exit 1

sed -i -e "s/\(partition=[a-z0-9_]*\).*--/\1 --emu-list=$QUEUE --/" start_emulation.csh

exit 0
