#!/bin/bash

set -e

sed -i -e 's/partition=\(.*\)_veloce/partition=high1h_veloce/' start_emulation.csh

exit 0
