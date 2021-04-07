#!/bin/bash

# file: 06a_synApps_prerequisites.sh
#
# Packages needed for building EPICS synApps.

sudo apt-get install -y  \
    git \
    libnet-dev \
    libpcap-dev \
    libusb-1.0-0-dev \
    libusb-dev \
    libx11-dev \
    libxext-dev \
    re2c \
    libx11-dev \
    x11-xserver-utils \
    xorg-dev \
    xvfb
