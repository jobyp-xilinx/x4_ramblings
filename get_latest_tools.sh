#!/bin/bash

set -e

XAM='/proj/x4_runs/Work/common/tools/artefact-manager/x4am.sh'

rm -rf tools.x86_64
tools_version=$($XAM build_versions --jfrog-config /home/jobyp/.jfrog/jfrog-cli.conf.v5 --product tools.x86_64 --report-path | tail -n1)
echo "latest tools is $tools_version"
$XAM download_build  --jfrog-config /home/jobyp/.jfrog/jfrog-cli.conf.v5 --extract --remove $tools_version

exit 0
