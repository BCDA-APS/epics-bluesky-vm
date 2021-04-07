#!/bin/bash

# file: 03b_setup_epics_extensions.sh

if [ "" == "${EPICS_ROOT}" ]; then
    echo EPICS_ROOT not defined.
    echo perhaps?  source /usr/local/epics/setup_base_env.sh
    exit 1
fi

cd ${EPICS_ROOT}
git clone https://github.com/epics-extensions/extensions ./opi
ln -s ./opi extensions

cd ./opi
sed -i \
    s:'MOTIF_LIB=/usr/lib64':'MOTIF_LIB=/usr/lib/x86_64-linux-gnu/':g \
    configure/os/CONFIG_SITE.linux-x86_64.linux-x86_64
sed -i \
    s:'X11_LIB=/usr/lib64':'X11_LIB=/usr/lib/x86_64-linux-gnu/':g \
    configure/os/CONFIG_SITE.linux-x86_64.linux-x86_64

cd ${EPICS_ROOT}
cat > ./setup_extensions_env.sh << EOF
# -----------------------------
# file: setup_extensions_env.sh
# add to ~/.bash_aliases
export EPICS_EXT=\${EPICS_ROOT}/opi
export EPICS_EXT_BIN=\${EPICS_EXT}/bin/\${EPICS_HOST_ARCH}
export EPICS_EXT_LIB=\${EPICS_EXT}/lib/\${EPICS_HOST_ARCH}
export PATH=\${PATH}:\${EPICS_EXT_BIN}
EOF
chmod +x ./setup_extensions_env.sh
