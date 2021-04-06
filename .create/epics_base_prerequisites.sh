#!/bin/bash

# file: epics_base_prerequisites.sh
#
# Packages needed for building EPICS base.
# Includes editor tools.

sudo apt-get install -y \
    apt-utils \
    build-essential \
    libreadline-dev \
    screen \
    nano \
    vim \
    geany

cat >> ~/setup_editor_env.sh << EOF
# -----------------------------
# file: setup_editor_env.sh
# add to ~/.bash_aliases
export EDITOR=nano
EOF
