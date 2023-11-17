#!/bin/bash

set -e

XAM='/proj/x4_runs/Work/common/tools/artefact-manager/x4am.sh'

rm -rf mcfw_x4.a0_veloce
fw_version=$($XAM build_versions --jfrog-config /home/jobyp/.jfrog/jfrog-cli.conf.v5 --product mcfw_x4.a0.stage1_veloce --report-path | tail -n1)
echo "latest f/w is $fw_version"
$XAM download_build --jfrog-config /home/jobyp/.jfrog/jfrog-cli.conf.v5 --extract --remove $fw_version
# pushd mcfw_x4.a0.stage1_veloce
# tar xfz *.tar.gz
# popd


exit 0
