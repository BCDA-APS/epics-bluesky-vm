#!/bin/bash

# file: 04a_epics_extensions_prerequisites.sh

sudo apt install -y \
    libxt-dev libxft-dev \
    libmotif-common libmotif-dev \
    libxmu-headers libxmu-dev \
    gitk git-gui

# # tools to discover what package provides libXm.a, needed for MEDM build
# sudo apt install apt-file
# sudo apt-file update
# apt-file search "libXm.a"
