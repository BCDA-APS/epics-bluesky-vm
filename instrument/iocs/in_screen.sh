#!/bin/bash
# file: in_screen.sh

SHELL_SCRIPT_NAME=${BASH_SOURCE:-${0}}
export THISDIR=$(dirname $(readlink -f ${SHELL_SCRIPT_NAME}))
/usr/bin/screen -d -m -S IOC_registers -h 5000 ${THISDIR}/run_ioc.sh
echo $(screen -ls)
