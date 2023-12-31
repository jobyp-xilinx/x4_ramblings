#!/bin/bash

source /proj/verif_release_ro/cbwa_initscript/current/cbwa_init.bash
module load /proj/emu_share/tools/scheduler/current/modulefile

set -e

squeue_out=$(squeue -u $(whoami) --noheader -o '%A:%N')
jobid=$(echo "$squeue_out" | cut -d: -f1)
comodel=$(echo "$squeue_out" | cut -d: -f2)

[[ -z "$jobid" ]] && echo "cannot ssh to a VM without jobid" && exit 1
echo "Comodel host is $comodel"

rtl_dir=$(squeue -j $jobid -o %Z --noheader)
ssh_config="$rtl_dir/ssh_config"


if [[ -e "$ssh_config" ]] ; then
    echo ssh -F "$ssh_config" veloce_vm "$@"
    ssh -F "$ssh_config" veloce_vm "$@"
else
    # relies on having a suitable ~/.ssh/config (Joby)
    echo ssh -J "$comodel" -S "~/.ssh/cm-${jobid}-%C" localhost "$@"
    ssh -J "$comodel" -S "~/.ssh/cm-${jobid}-%C" localhost "$@"
fi

exit 0

# Local Variables:
# mode: sh
# End:
