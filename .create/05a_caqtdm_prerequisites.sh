#!/bin/bash

# file: 05a_caqtdm_prerequisites.sh

sudo apt install -y \
    build-essential \
    libfontconfig1 \
    libglu1-mesa-dev \
    libpython3.8-dev \
    libqt5svg5 \
    libqt5svg5-dev \
    libqt5x11extras5-dev \
    libqwt-qt5-dev \
    mesa-common-dev \
    qt5-default \
    qt5-qmake \
    qttools5-dev \
    qttools5-dev-tools

cd /usr/lib
sudo ln -s libqwt-qt5.so ./libqwt.so
