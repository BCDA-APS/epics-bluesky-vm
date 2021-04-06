#!/bin/bash

# file: 05b_build_medm.sh

if [ "" == "${EPICS_EXT}" ]; then
    echo EPICS_ROOT not defined.
    echo perhaps?  source /usr/local/epics/setup_base_env.sh
    echo perhaps?  source /usr/local/epics/setup_extensions_env.sh
    exit 1
fi

cd ${EPICS_EXT}/src
git clone https://github.com/epics-extensions/medm

# libXp not available and can be removed
sed -i \
    s:'USR_LIBS_Linux = Xm Xt Xp Xmu X11 Xext':'USR_LIBS_Linux = Xm Xt Xmu X11 Xext':g \
    medm/medm/Makefile

cd ..
make -j4  2>&1 | tee build.log
