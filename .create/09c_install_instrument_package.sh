#!/bin/bash

# file: 09c_install_instrument_package.sh

cd ~
git clone https://github.com/BCDA-APS/bluesky_instrument_training ./bluesky

export BLUESKY_CATALOG_DIR=~/.local/share/intake

mkdir -p ${BLUESKY_CATALOG_DIR}
cat >> ${BLUESKY_CATALOG_DIR}/training.yml << EOF
# - - - - - - - - - - - - - - - -
# file: training.yml
# purpose: Configuration file to connect Bluesky databroker with MongoDB
# For 2021-03 Python Training at APS

# Copy to: ~/.local/share/intake/training.yml
# Create subdirectories as needed

sources:
  training:
    args:
      asset_registry_db: mongodb://localhost:27017/training-bluesky
      metadatastore_db: mongodb://localhost:27017/training-bluesky
    driver: bluesky-mongo-normalized-catalog
EOF

sed -i s:'class_2021_03':'training':g ~/bluesky/instrument/framework/initialize.py