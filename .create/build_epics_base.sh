#!/bin/bash

# file: build_epics_base.sh

export EPICS_ROOT=/usr/local/epics
export EPICS_BASE_NAME=base-7.0.5

# TODO: mkdir ${EPICS_ROOT} and make it writeable by ${USER}

cd ~/Downloads
wget https://epics.anl.gov/download/base/${EPICS_BASE_NAME}.tar.gz
cd ${EPICS_ROOT}
tar xzf ~/Downloads/${EPICS_BASE_NAME}.tar.gz
ln -s ./${EPICS_BASE_NAME} ./base
cd ./base
export EPICS_HOST_ARCH=$(./base/startup/EpicsHostArch)

make -j4 all CFLAGS="-fPIC" CXXFLAGS="-fPIC"  2>&1 | tee build.log

export EPICS_BASE_ROOT=\${EPICS_ROOT}/\${EPICS_BASE_NAME}
export PATH=\${PATH}:\${EPICS_BASE_ROOT}/bin/\${EPICS_HOST_ARCH}

# TODO: env vars for ~/.bash_aliases
