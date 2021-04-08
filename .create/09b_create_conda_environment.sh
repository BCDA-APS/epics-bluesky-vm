#!/bin/bash

# file: 09b_create_conda_environment.sh

cd ~/Downloads
wget https://raw.githubusercontent.com/BCDA-APS/use_bluesky/main/install/environment_2021_1.yml

sed -i s+'- pip:'+'# - pip:'+g ~/Downloads/environment_2021_1.yml
sed -i s:'- bluesky-live':'# - bluesky-live':g ~/Downloads/environment_2021_1.yml
sed -i s:'- super-state-machine':'# - super-state-machine':g ~/Downloads/environment_2021_1.yml
sed -i s:'- sphinx-rtd-theme':'# - sphinx-rtd-theme':g ~/Downloads/environment_2021_1.yml
sed -i s:'- happi':'# - happi':g ~/Downloads/environment_2021_1.yml

source ~/Apps/miniconda3/bin/activate
conda env create -f ~/Downloads/environment_2021_1.yml
conda env list

export BLUESKY_ENVIRONMENT=bluesky_2021_1
cat >> ~/.bash_aliases << EOF
# -----------------------------
# bluesky environment
export BLUESKY_ENVIRONMENT=${BLUESKY_ENVIRONMENT}
alias become_bluesky='conda activate \${BLUESKY_ENVIRONMENT}'
EOF
