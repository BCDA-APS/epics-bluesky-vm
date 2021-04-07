#!/bin/bash
# file: in_screen.sh
export BASE=$(dirname bash)
/usr/bin/screen -d -m -S IOC_registers -h 5000 /run_ioc.sh
echo $(screen -ls)
