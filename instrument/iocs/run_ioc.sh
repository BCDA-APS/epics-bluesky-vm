#!/bin/bash
# file: run_ioc.sh

export BASE=$(dirname bash)
export SOFT_IOC=$(which softIoc)

${SOFT_IOC} -d ${BASE}/registers.db
