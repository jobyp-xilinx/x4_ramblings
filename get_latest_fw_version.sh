#!/bin/bash

set -e

XAM='/proj/x4_runs/Work/common/tools/artefact-manager/x4am.sh'

pushd /proj/x4_runs/Work/jobyp/shared_dir_on_x4_runs/src/x2_fw
if git branch | grep -E '\*' | grep -Eq master; then
    :
else
    git checkout master
fi
git pull --recurse-submodules

git log -n1
popd

fw_version=$($XAM build_versions --product mcfw_x4.a0.stage1_veloce --report-path | tail -n1)
echo "latest f/w in Artifactory is $fw_version"

rtl_version=$($XAM build_versions --product rtl_x4.veloce --report-path | tail -n1)
echo "latest rtl is $rtl_version"


snapper_version=$($XAM build_versions --product snapper_x4 --report-path | tail -n1)
echo "latest snapper_x4 is $snapper_version"

tools_version=$($XAM build_versions --product tools.x86_64 --report-path | tail -n1)
echo "latest tools is $tools_version"


rtl_version=$($XAM build_versions --product rtl_x4.stage1_veloce --report-path | tail -n1)
echo "latest rtl is $rtl_version"


exit 0
