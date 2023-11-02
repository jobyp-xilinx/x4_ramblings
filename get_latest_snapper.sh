#!/bin/bash

set -e

XAM='/proj/x4_runs/Work/common/tools/artefact-manager/x4am.sh'

rm -rf snapper_x4
snapper_version=$($XAM build_versions --product snapper_x4 --report-path | tail -n1)
echo "latest snapper_x4 is $snapper_version"
$XAM download_build --extract --remove $snapper_version

echo 

exit 0
