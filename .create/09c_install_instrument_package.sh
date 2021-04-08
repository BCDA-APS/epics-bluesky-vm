#!/bin/bash

# file: 09c_install_instrument_package.sh

cd ~

export BLUESKY_CATALOG_DIR=~/.local/share/intake
export INST=~/bluesky/instrument

mkdir -p ${BLUESKY_CATALOG_DIR}
cp ~/bluesky/.create/training.yml ${BLUESKY_CATALOG_DIR}/training.yml

sed -i s:'class_2021_03':'training':g ${INST}/framework/initialize.py

# Configure starter for this environment.
# sed -i s:'=class_2021_03':'=bluesky_2021_1':g ~/bluesky/blueskyStarter.sh
ln -s ~/bluesky/blueskyStarter.sh ~/bin/blueskyStarter.sh
