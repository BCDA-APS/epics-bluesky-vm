#!/bin/bash

# file: 09b_create_conda_environment.sh

cd ~/Downloads
wget https://raw.githubusercontent.com/BCDA-APS/use_bluesky/main/install/environment_2021_1.yml
conda env create -f ~/Downloads/environment_2021_1.yml
conda env list

export BLUESKY_ENV=bluesky_2021_1
cat >> ~/.bash_aliases << EOF
# -----------------------------
# bluesky environment
export BLUESKY_ENV=${BLUESKY_ENV}
alias become_bluesky='conda activate \${BLUESKY_ENV}'
EOF
