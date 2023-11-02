#!/bin/bash

set -e

XAM='/proj/x4_runs/Work/common/tools/artefact-manager/x4am.sh'

rm -rf mcfw_x4.a0_veloce
fw_version=$($XAM build_versions --product mcfw_x4.a0_veloce --report-path | tail -n1)
echo "latest f/w is $fw_version"
$XAM download_build --extract --remove $fw_version


exit 0
