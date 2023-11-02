#!/bin/bash

set -e

XAM='/proj/x4_runs/Work/common/tools/artefact-manager/x4am.sh'

rm -rf tools.x86_64
fw_version=$($XAM build_versions --product tools.x86_64 --report-path | tail -n1)
echo "latest tools is $fw_version"
$XAM download_build --extract --remove $fw_version


exit 0
