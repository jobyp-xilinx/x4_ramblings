#!/bin/bash

set -e

sed -i -e 's/partition=\(.*\)_veloce/partition=regr_veloce/' start_emulation.csh

exit 0
