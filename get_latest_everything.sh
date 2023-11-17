#!/bin/bash

get_latest_fw.sh &
get_latest_rtl.sh &
get_latest_snapper.sh &
get_latest_tools.sh &
sleep 5s;

wait

exit 0
