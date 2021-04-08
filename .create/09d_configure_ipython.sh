#!/bin/bash

# file: 09d_configure_ipython.sh

if [ "" == "${BLUESKY_ENVIRONMENT}" ]; then
    echo BLUESKY_ENVIRONMENT not defined.
    exit 1
fi

export IPYTHON_DIR=${HOME}/.ipython-bluesky
cat >> ~/.bash_aliases << EOF
# - - - - - - - - - - - - - - - -
# IPython directory
export IPYTHON_DIR=${IPYTHON_DIR}
EOF

source ${CONDA_PREFIX}/bin/activate
conda activate ${BLUESKY_ENVIRONMENT}

ipython profile create --ipython-dir=${IPYTHON_DIR} --profile=bluesky
cp ~/bluesky/run_instrument.py ${IPYTHON_DIR}/profile_bluesky/startup/
