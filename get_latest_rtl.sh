#!/bin/bash

set -e

XAM='/proj/x4_runs/Work/common/tools/artefact-manager/x4am.sh'

rm -rf rtl_x4.veloce
rtl_version=$($XAM build_versions --product rtl_x4.veloce --report-path | tail -n1)
echo "latest rtl is $rtl_version"
$XAM download_build --extract --remove $rtl_version


exit 0
