#!/bin/bash

set -e

XAM='/proj/x4_runs/Work/common/tools/artefact-manager/x4am.sh'
MANIFEST=$1

[[ -z "$MANIFEST" ]] && echo "Cannot proceed without manifest. Usage $0 <MANIFEST_FROM_ARTIFACTORT>" && exit 1
$XAM --server-id xcbartifactory01 --jfrog-config /home/jobyp/.jfrog/jfrog-cli.conf.v5 download  --extract $MANIFEST

exit 0
