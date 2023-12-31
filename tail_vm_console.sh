#!/bin/bash

source /proj/verif_release_ro/cbwa_initscript/current/cbwa_init.bash
module load /proj/emu_share/tools/scheduler/current/modulefile

set -e

squeue_out=$(squeue -u $(whoami) --noheader -o '%A:%N')
jobid=$(echo "$squeue_out" | cut -d: -f1)
comodel=$(echo "$squeue_out" | cut -d: -f2)

[[ -z "$jobid" ]] && echo "cannot proceed without jobid" && exit 1
echo "Comodel host is $comodel"
rtl_dir=$(squeue --noheader -o %Z -j $jobid)

echo ssh $comodel -- tail -f $rtl_dir/vm-console.out
ssh $comodel -- tail -f $rtl_dir/vm-console.out

exit 0

# Local Variables:
# mode: sh
# End:
