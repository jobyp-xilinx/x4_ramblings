#!/bin/bash

set -e

XAM='/proj/x4_runs/Work/common/tools/artefact-manager/x4am.sh'

rm -rf rtl_x4.stage1_veloce
rtl_version=$($XAM build_versions --jfrog-config /home/jobyp/.jfrog/jfrog-cli.conf.v5 --product rtl_x4.stage1_veloce --report-path | tail -n1)
echo "latest rtl is $rtl_version"
$XAM download_build --jfrog-config /home/jobyp/.jfrog/jfrog-cli.conf.v5 --extract --remove $rtl_version
# pushd rtl_x4.veloce
# tar xfz *.tar.gz
# popd

exit 0
