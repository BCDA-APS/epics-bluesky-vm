#!/bin/bash

# manage the soft IOCs running in Docker containers
#
# NOTE: start/restart mean start/restart the docker container
#   This will be a complete reset of the IOCs.  All PVs set back to defaults.

# run by  crontab -e
#              field          allowed values
#              -----          --------------
#              minute         0-59
#              hour           0-23
#              day of month   1-31
#              month          1-12 (or names, see below)
#	       day of week    0-7 (0 or 7 is Sun, or use names)
#
#  # auto-start the EPICS soft IOCs in docker containers
#  */2 * * * *  bash /home/USER/bin/ioc_manager.sh checkup 2>&1 > /dev/null

SHELL_SCRIPT_NAME=${BASH_SOURCE:-${0}}

export BINDIR=$(dirname $(readlink -f ${SHELL_SCRIPT_NAME}))
export START_AD=${BINDIR}/$(/bin/grep "start_adsim" ${BINDIR}/start_iocs.sh)
export START_GP=${BINDIR}/$(/bin/grep "start_xxx" ${BINDIR}/start_iocs.sh)
export AD_NAME=ioc$(echo $START_AD | /usr/bin/awk '{print $2}')
export GP_NAME=ioc$(echo $START_GP | /usr/bin/awk '{print $2}')

SELECTION=${1:-usage}
export PATH=${BINDIR}:${PATH}
export LOG_FILE=/tmp/ioc_manager.log
BASENAME=$(basename ${SHELL_SCRIPT_NAME})

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function is_running() {
    ad_container=$(/usr/bin/docker ps | /bin/grep " ${AD_NAME}\$")
    gp_container=$(/usr/bin/docker ps | /bin/grep " ${GP_NAME}\$")
    result=0
    if [ "" == "${ad_container}" ]; then
        result=$((result+1))
    fi
    if [ "" == "${gp_container}" ]; then
        result=$((result+2))
    fi
    return ${result}
}

function checkup () {
    if ! is_running; then
        echo "# $(date --iso-8601='seconds') checkup : restart IOCs" 2>&1 >> ${LOG_FILE}
        restart
    fi
}

function restart() {
    echo $(date): "Restarting both IOCs:  (${AD_NAME} and ${GP_NAME})"
    echo "Command: ${BINDIR}/start_iocs.sh"
    echo "# $(date --iso-8601='seconds') restart ${BINDIR}/start_iocs.sh" 2>&1 >> ${LOG_FILE}
    ${BINDIR}/start_iocs.sh 2>&1 | tee -a ${LOG_FILE}
}

function start() {
    echo start
    if is_running; then
        echo "Both IOCs (${AD_NAME} and ${GP_NAME}) are running."
    else
        echo "Starting IOCs: (${AD_NAME} and ${GP_NAME})"
        echo "# $(date --iso-8601='seconds') start ${BINDIR}/start_iocs.sh" 2>&1 >> ${LOG_FILE}
        ${BINDIR}/start_iocs.sh 2>&1 | tee -a ${LOG_FILE}
    fi
}

function status() {
    if is_running; then
        echo "Both IOCs (${AD_NAME} and ${GP_NAME}) are running."
    else
        echo "One or both IOCs are not running."
    fi
}

function stop() {
    echo "Stopping IOC ${AD_NAME}"
    echo "# $(date --iso-8601='seconds') stop ${BINDIR}/remove_container.sh ${AD_NAME}" 2>&1 >> ${LOG_FILE}
    ${BINDIR}/remove_container.sh ${AD_NAME} 2>&1 | tee -a ${LOG_FILE}

    echo "Stopping IOC ${GP_NAME}"
    echo "# $(date --iso-8601='seconds') stop ${BINDIR}/remove_container.sh ${AD_NAME}" 2>&1 >> ${LOG_FILE}
    ${BINDIR}/remove_container.sh ${GP_NAME} 2>&1 | tee -a ${LOG_FILE}
}

function usage() {
    echo "Usage: ${BASENAME} {start|stop|restart|status|checkup}"
    echo ""
    echo "    COMMANDS"
    echo "        checkup   check that IOCs are running, start if not"
    echo "        restart   hard restart IOCs (reset to defaults, no autosave)"
    echo "        start     start IOCs"
    echo "        status    report if IOCs are running"
    echo "        stop      stop IOC"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

case ${SELECTION} in
    checkup) checkup ;;
    restart) restart ;;
    start) start ;;
    status) status ;;
    stop | kill) stop ;;
    *) usage ;;
esac
