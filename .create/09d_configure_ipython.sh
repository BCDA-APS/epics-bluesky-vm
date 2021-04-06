#!/bin/bash

# file: 09d_configure_ipython.sh

if [ "" == "${BLUESKY_ENV}" ]; then
    echo BLUESKY_ENV not defined.
    exit 1
fi

export IPYTHON_DIR=${HOME}/.ipython-bluesky
cat >> ~/.bash_aliases << EOF
# - - - - - - - - - - - - - - - -
# IPython directory
export IPYTHON_DIR=${IPYTHON_DIR}
EOF

conda activate ${BLUESKY_ENV}
ipython profile create --ipython-dir=${IPYTHON_DIR} --profile=bluesky
cat > ${IPYTHON_DIR}/profile_bluesky/startup/run_instrument.py << EOF
# - - - - - - - - - - - - - - - -
"start bluesky in IPython session"

import os
import sys
sys.path.append(os.path.join(os.environ["HOME"], "bluesky"))

from instrument.collection import *
EOF
