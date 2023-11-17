#!/bin/bash

set -e

XAM='/proj/x4_runs/Work/common/tools/artefact-manager/x4am.sh'

# pushd /proj/x4_runs/Work/jobyp/src/x4-fw
# if git branch | grep -E '\*' | grep -Eq master; then
#     :
# else
#     git checkout master
# fi
# git pull --recurse-submodules

# git log -n1
# popd

fw_version=$($XAM build_versions --product mcfw_x4.a0.stage2_veloce --jfrog-config /home/jobyp/.jfrog/jfrog-cli.conf.v5 --report-path | tail -n1)
echo "latest f/w in Artifactory is $fw_version"
$XAM download_build --jfrog-config /home/jobyp/.jfrog/jfrog-cli.conf.v5 --extract --remove $fw_version


exit 0
