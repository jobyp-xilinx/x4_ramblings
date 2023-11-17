#!/bin/bash

source /proj/verif_release_ro/cbwa_initscript/current/cbwa_init.bash
module load /proj/emu_share/tools/scheduler/current/modulefile

set -e

squeue_out=$(squeue -u $(whoami) --noheader -o '%A:%N')
jobid=$(echo "$squeue_out" | cut -d: -f1)
comodel=$(echo "$squeue_out" | cut -d: -f2)

[[ -z "$jobid" ]] && echo "cannot proceed without jobid" && exit 1
echo "Comodel host is $comodel"
rtl_dir=$(sacct --noheader -o EmuWorkDir%-4096 -j $jobid | cut -d' ' -f1)

grep -E '^#[ ]*x[24]_veloce_wrap.mgc_xrtl_uart_i.uart :' $rtl_dir/veloce.log/velrun.transcript
echo tail -f $rtl_dir/mc-uart.out
ssh $comodel "tail -f $rtl_dir/mc-uart.out" || tail -f $rtl_dir/mc-uart.out

exit 0

# Local Variables:
# mode: sh
# End:
