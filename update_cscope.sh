#!/bin/bash

set -ex

find . -name '*.[ch]' -type f > cscope.files
ctags -L cscope.files
cscope -q

exit 0
