#!/bin/bash

# file: 09a_install_miniconda.sh

mkdir -p ~/Apps
cd ~/Downloads
wget http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh

bash Miniconda3-latest-Linux-x86_64.sh -b -p ~/Apps/miniconda3

source ~/Apps/miniconda3/bin/activate
conda init
