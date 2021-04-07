#!/bin/bash

# file: 02b_build_epics_base.sh

export EPICS_ROOT=/usr/local/epics
export EPICS_BASE_NAME=base-7.0.5

if [ ! -d "${EPICS_ROOT}" ]; then
    echo First, create directory ${EPICS_ROOT}
    echo suggestion: sudo mkdir ${EPICS_ROOT}
    echo ... then make it writeable by ${USER}
    echo suggestion: sudo chown ${USER}:${USER} ${EPICS_ROOT}
    exit 1
fi

cd ~/Downloads
wget https://epics.anl.gov/download/base/${EPICS_BASE_NAME}.tar.gz
cd ${EPICS_ROOT}
tar xzf ~/Downloads/${EPICS_BASE_NAME}.tar.gz
ln -s ./${EPICS_BASE_NAME} ./base
cd ./base
export EPICS_HOST_ARCH=$(./startup/EpicsHostArch)
echo Building for EPICS host architecture: ${EPICS_HOST_ARCH}

make -j4 all CFLAGS="-fPIC" CXXFLAGS="-fPIC"  2>&1 | tee build.log

# env vars for ~/.bash_aliases
cd ${EPICS_ROOT}
cat > ./setup_base_env.sh << EOF
# -----------------------------
# file: setup_base_env.sh
# add to ~/.bash_aliases
export EPICS_ROOT=${EPICS_ROOT}
export EPICS_BASE_NAME=${EPICS_BASE_NAME}
export EPICS_HOST_ARCH=${EPICS_HOST_ARCH}
export EPICS_BASE_ROOT=\${EPICS_ROOT}/\${EPICS_BASE_NAME}
export PATH=\${PATH}:\${EPICS_BASE_ROOT}/bin/\${EPICS_HOST_ARCH}
EOF
chmod +x ./setup_base_env.sh
