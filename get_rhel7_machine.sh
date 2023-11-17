#!/bin/bash

export AMDLSFCLUSTER=atlemu1
source /tool/pandora/etc/lsf/profile.lsf

lsf_bsub -P emu-aecg -Is -q regr_high -R "rusage[mem=128000] select[(type==RHEL7_64) && (csbatch||dedicated)]" bash

exit 0
