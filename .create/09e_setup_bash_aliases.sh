#!/bin/bash

# file: 09e_setup_bash_aliases.sh

if [ "" == "${EPICS_ROOT}" ]; then
    echo EPICS_ROOT not defined.
    echo calling:  source /usr/local/epics/setup_base_env.sh
    source /usr/local/epics/setup_base_env.sh
fi

cat ${EPICS_ROOT}/setup_base_env.sh  >> ~/.bash_aliases
cat ${EPICS_ROOT}/setup_caqtdm_env.sh  >> ~/.bash_aliases
cat ${EPICS_ROOT}/setup_extensions_env.sh  >> ~/.bash_aliases
cat ${EPICS_ROOT}/setup_synApps_env.sh  >> ~/.bash_aliases
cat ${HOME}/setup_editor_env.sh  >> ~/.bash_aliases
