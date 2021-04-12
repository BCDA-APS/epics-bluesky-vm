#!/bin/bash

# file: start_MEDM_ad.sh

export EPICS_DISPLAY_PATH=/tmp/docker_ioc/synapps-6.1-ad-3.7/screens/adl/

medm -x -macro "P=ad:, R=cam1:" simDetector.adl &
