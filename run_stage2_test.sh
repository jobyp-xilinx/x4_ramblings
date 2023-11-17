#!/bin/bash

set -e

VARIANT="$1"
TEST="$2"
MANIFEST="$3"

[[ -z "${VARIANT}" ]] && echo "usage: $0 <full_featured|low_latency|packed_stream|dpdk> <true|trivial>  [MANIFEST]" && exit 1
[[ -z "${TEST}" ]] && echo "usage: $0 <full_featured|low_latency|packed_stream|dpdk> <true|trivial> [MANIFEST]" && exit 1

rm -vf snapper_${TEST}_*.log
if [[ -z "${MANIFEST}" ]]; then 
    velocetool setup --rtl ./rtl_x4.stage2_pcie_veloce --snapper ./snapper_x4 --firmware ./mcfw_x4.a0.stage2_veloce --tools ./tools.x86_64 --fw-variant ${VARIANT} --stage2 # --pcie-trace
    #velocetool setup --rtl ./rtl_x4.stage2_pcie_veloce --snapper ./snapper_x4 --firmware ./custom_fw --tools ./tools.x86_64 --fw-variant ${VARIANT} # --pcie-trace
else
    velocetool setup --manifest "${MANIFEST}"
fi

: > snapper_${TEST}_${VARIANT}.log

ITERATIONS=1
#[[ "x$TEST" == "true" ]] && ITERATIONS=5

#TEST='--seed 122535207 --sched-always :evq_phase_check=off @p=port:fc=legacy many_queues.melee.some_to_some:pkt_count=10000,port=@p:topology=straight'

for i in $(seq 1 $ITERATIONS)
do
    printf "snapper ${TEST} attempt $i\n\n\n\n" | tee -a snapper_${TEST}_${VARIANT}.log
    #printf "snapper ${TEST} attempt $i\n\n\n\n" | tee -a snapper_${VARIANT}.log 
    ssh_vm.sh "lspci -d 1924: -vv" | tee -a snapper_${TEST}_${VARIANT}.log
    ssh_vm.sh "/tmp/tools.x86_64/mc-comms/cmdclient -c 'getcaps; version; quit;' tlp=0" 2>&1 | tee -a snapper_${TEST}_${VARIANT}.log
    ssh_vm.sh "cd /tmp/snapper_x4/snapper; ./snap -- -V -V -V ${TEST}"  2>&1 | tee -a snapper_${TEST}_${VARIANT}.log
    #ssh_vm "cd /tmp/snapper_x4/snapper; ./snap -- ${TEST}"  2>&1 | tee -a snapper_${VARIANT}.log
    #ssh_vm "cd /tmp/snapper_x4/snapper; ./snap -- --seed 1080442256 --sched-always :evq_phase_check=off qflush.tx_corrupt_unmap_and_flush"  2>&1 | tee -a snapper_qflush_${VARIANT}.log
    #timeout 600s ssh_vm "cd /tmp/snapper_x4/snapper; ./snap -- -V -V -V @vi=vi0 trivial:frame_len=60:rx_timeout=5000000,func=pf0,vi=@vi"  2>&1 | tee -a snapper_${TEST}_${VARIANT}.log
done
ssh_vm.sh 'shutdown -h now'

exit 0
