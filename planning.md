# Preparation of VM

Install EPICS, synApps,GUIs, Bluesky and related components
to create an APS beam line simulator for training, education,
and development related to APS-U.

- [Preparation of VM](#preparation-of-vm)
  - [VirtualBox VM](#virtualbox-vm)
  - [First steps after operating system installation](#first-steps-after-operating-system-installation)
  - [Install Editors](#install-editors)
  - [EPICS base](#epics-base)
    - [Preparation](#preparation)
    - [Environment variables](#environment-variables)
    - [Create directory for EPICS](#create-directory-for-epics)
    - [Download and build](#download-and-build)
    - [test EPICS base installation](#test-epics-base-installation)
  - [EPICS synApps](#epics-synapps)
  - [EPICS GUIs](#epics-guis)
    - [MEDM](#medm)
    - [Qt5 library, Qt designer, & Qwt library](#qt5-library-qt-designer--qwt-library)
    - [caQtDM](#caqtdm)
  - [Bluesky](#bluesky)
    - [Docker](#docker)
    - [MongoDB](#mongodb)
    - [Python](#python)
    - [Conda environment](#conda-environment)
    - [`instrument` package](#instrument-package)
  - [Reboot](#reboot)

## VirtualBox VM

term | value
:--- | :---
Name | EPICS-Bluesky-Simulator
Type | Linux
Version | Ubuntu (64-bit)
RAM | 2048 MB
Hard disk type | VDI (VirtualBox Disk Image), dynamically allocated
Download URL | [Linux Mint](https://linuxmint.com/edition.php?id=285)
VDI Size | 30 GB
Release | Linux Mint 20.1 "Ulyssa" - MATE (64-bit)
Your name | APSU EPICS beam line Bluesky Simulator
Computer's name | apsu-beamline-simulator
user | `apsu`
password | TODO:
Login automatically | Yes

1. Add the downloaded ISO file as an optical disk, Live CD/DVD image.
1. Start the new VM.
1. Start the Live installer: `Install Linux Mint` icon on desktop
1. `English`
1. `English (US)` keyboard
1. check the checkbox (`Install multimedia codecs`)
1. `Erase and Install` ... press `[Install Now]` button
1. accept changes to disk (the new VDI disk)
1. Time Zone: Chicago
1. `Who are you?`  see table above

Installation proceeds to completion.

1. Restart Now
2. Unmount the installation disk from (virtual) Optical Drive: *Devices* menu: *Optical Drives*: remove disk from virtual drive
3. Press `Enter` key to restart

## First steps after operating system installation

**Optional**

Complete the steps suggested by the welcome wizard

**Install the VBox Guest Additions**

1. *Devices* menu: *Insert Guest Additions CD Image*
2. Open the *VBox_GAs...* folder
3. Run `autorun.sh` (if it does not autorun)
4. *Devices* menu: *Optical Drives*: *Remove disk from virtual drive*
5. *Devices* menu: *Shared Clipboard*: *Bidirectional**

- Deactivate screen lock from screen saver (since VM host policies cover that security aspect)

Restart

```sh
sudo /sbin/shutdown -r now
```

**Update OS**

After installing the Ubuntu-derivative operating, this command updates
the OS from a command-line terminal.  Start such a terminal from the
Desktop by the pressing this combination of keys at the same time:
`<ctrl><alt>T`

(Use this command any time the OS needs additional update.)

```sh
sudo apt-get update  -y && sudo apt-get upgrade -y
```

## Install Editors

```sh
sudo apt-get install -y nano vim geany
```

Now, proceed to build or extend `~/.bash_aliases`.
It might be necessary to add code to `~/.bashrc` to call
`~/.bash_aliases` since some distributions do not include this part:

```sh
if [ "$(grep bash_aliases ~/.bashrc)" == "" ]; then
echo Adding call to ~/.bash_aliases from ~/.bashrc
cat >> ~/.bashrc << EOF
# - - - - - - - - -
# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
EOF
fi


cat >> ~/.bash_aliases << EOF
export EDITOR=nano
EOF
```

## EPICS base

### Preparation

Next, install packages needed for building EPICS base.  Includes editor tools.

```sh
sudo apt-get install -y \
    apt-utils \
    build-essential \
    libreadline-dev \
    screen
```

### Environment variables

```sh

cat >> ~/.bash_aliases << EOF
export EPICS_ROOT=/usr/local/epics
export EPICS_BASE_NAME=base-7.0.5
export EPICS_HOST_ARCH=linux-x86_64
export EPICS_BASE_ROOT=\${EPICS_ROOT}/\${EPICS_BASE_NAME}
export PATH=\${PATH}:\${EPICS_BASE_ROOT}/bin/\${EPICS_HOST_ARCH}
EOF

```

### Create directory for EPICS

```sh
. ~/.bash_aliases

sudo mkdir ${EPICS_ROOT}
sudo chown ${USER}:${USER} ${EPICS_ROOT}
```

### Download and build

```sh
cd ~/Downloads
wget https://epics.anl.gov/download/base/${EPICS_BASE_NAME}.tar.gz
cd ${EPICS_ROOT}
tar xzf ~/Downloads/${EPICS_BASE_NAME}.tar.gz
ln -s ./${EPICS_BASE_NAME} ./base
cd ./base
make -j4 all CFLAGS="-fPIC" CXXFLAGS="-fPIC"  2>&1 | tee build.log
```

### test EPICS base installation

<details>
<summary>Optional</summary>

First, create a test database for EPICS.  This describes the PVs to test.

```sh
cd ~


cat > ~/Documents/demo.db << EOF
# demo.db
# Demonstration database for use with EPICS base application: softIoc

# MACROS
#
#  IOC  PV prefix for this database (default: softIoc_demo:)
#
# EXAMPLES
#
#    softIoc -d ./demo.db
#    softIoc -m IOC=demo: -d ./demo.db

record(ao, "\$(IOC=softIoc_demo:)ao")
record(bo, "\$(IOC=softIoc_demo:)bo")
record(longout, "\$(IOC=softIoc_demo:)longout")
record(stringout, "\$(IOC=softIoc_demo:)stringout")
EOF

```

Test the `softIoc` works:

Start the soft IOC: `softIoc -d ~/Documents/demo.db`

```sh
~$ softIoc -d ~/Documents/demo.db
apsu@apsu-beamline-simulator:~$ softIoc -d ~/Documents/demo.db
Starting iocInit
############################################################################
## EPICS R7.0.5
## Rev. 2021-03-25T13:49-0500
############################################################################
iocRun: All initialization complete
epics>
```

List all the PVs in the database: `dbl`

```sh
epics> dbl
softIoc_demo:longout
softIoc_demo:ao
softIoc_demo:bo
softIoc_demo:stringout
epics>
```

Exit the soft IOC: `exit`

```sh
epics> exit
apsu@apsu-beamline-simulator:~$
```

Should have the linux command line prompt (`~$ `) again.

Run the soft IOC in the background (as name `demoIOC`) to test linux command line tools.

```sh
~$ screen -dmS demoIOC softIoc -m IOC=demo: -d ~/Documents/demo.db
~$ caget demo:ao
demo:ao                        0
~$ cainfo demo:ao
demo:ao
    State:            connected
    Host:             10.0.2.15:5064
    Access:           read, write
    Native data type: DBF_DOUBLE
    Request type:     DBR_DOUBLE
    Element count:    1
~$ caput demo:ao 2.345
Old : demo:ao                        0
New : demo:ao                        2.345
~$
```

Shutdown the `demoIOC` in the screen session.

```sh
~$ screen -r demoIOC
Starting iocInit
############################################################################
## EPICS R7.0.5
## Rev. 2021-03-25T02:39-0500
############################################################################
iocRun: All initialization complete
epics>
```

As before, type `exit` to stop the IOC.

</details>

## EPICS synApps

```sh
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

export ENV HASH=R6-2
export MOTOR_HASH=R7-2-2
export AD_HASH=R3-10
export CAPUTRECORDER_HASH=master

export SYNAPPS="${EPICS_ROOT}/synApps"
export SUPPORT="${SYNAPPS}/support"
export PATH="${PATH}:${SUPPORT}/utils"

export AREA_DETECTOR=${SUPPORT}/areaDetector-${AD_HASH}
export MOTOR=${SUPPORT}/motor-${MOTOR_HASH}
export XXX=${SUPPORT}/xxx-R6-2
export CAPUTRECORDER=${SUPPORT}/caputRecorder-${CAPUTRECORDER_HASH}
export IOCXXX=${XXX}/iocBoot/iocxxx


cat >> ~/.bash_aliases << EOF
export SYNAPPS="\${EPICS_ROOT}/synApps"
export SUPPORT="\${SYNAPPS}/support"
export PATH="\${PATH}:\${SUPPORT}/utils"
EOF


cd ${EPICS_ROOT}
wget https://raw.githubusercontent.com/EPICS-synApps/support/${HASH}/assemble_synApps.sh


cat > ./.edit_assemble_synApps.sh << EOF
#!/bin/bash

# edit the assemble_synApps.sh script
# to download and prepare for building synApps

# EPICS base
sed -i s:'/APSshare/epics/base-3.15.6':'${EPICS_BASE_ROOT}':g assemble_synApps.sh

# do NOT use these modules
_MODULES_=""
_MODULES_+=" ALLENBRADLEY"
_MODULES_+=" CAMAC"
_MODULES_+=" DAC128V"
_MODULES_+=" DELAYGEN"
_MODULES_+=" DXP"
_MODULES_+=" DXPSITORO"
_MODULES_+=" GALIL"
_MODULES_+=" IP330"
_MODULES_+=" IPUNIDIG"
_MODULES_+=" LOVE"
_MODULES_+=" MCA"
_MODULES_+=" MEASCOMP"
_MODULES_+=" QUADEM"
_MODULES_+=" SOFTGLUE"
_MODULES_+=" SOFTGLUEZYNQ"
_MODULES_+=" VAC"
_MODULES_+=" VME"
_MODULES_+=" YOKOGAWA_DAS"
_MODULES_+=" XSPRESS3"

for mod in \${_MODULES_}; do
  cmd="sed -i s:'\${mod}=':'#+#\${mod}=':g assemble_synApps.sh"
  echo \${cmd}
  eval \${cmd}
done

# use these modules from their GitHub master branch(es)

_MODULES_=""
_MODULES_+=" ALIVE"
_MODULES_+=" AREA_DETECTOR"
_MODULES_+=" ASYN"
_MODULES_+=" AUTOSAVE"
_MODULES_+=" BUSY"
_MODULES_+=" CALC"
_MODULES_+=" CAPUTRECORDER"
_MODULES_+=" DEVIOCSTATS"
_MODULES_+=" IP"
_MODULES_+=" IPAC"
_MODULES_+=" LUA"
_MODULES_+=" MODBUS"
_MODULES_+=" MOTOR"
_MODULES_+=" OPTICS"
_MODULES_+=" SSCAN"
_MODULES_+=" STD"
_MODULES_+=" STREAM"
_MODULES_+=" XXX"

# for mod in \${_MODULES_}; do
#   cmd="sed -i s:'^\${mod}=\S*\\$':'\${mod}=master':g assemble_synApps.sh"
#   echo \${cmd}
#   eval \${cmd}
# done
for mod in "AD"; do
  cmd="sed -i s:'^\${mod}=\S*\\$':'\${mod}=\${AD_HASH}':g assemble_synApps.sh"
  echo \${cmd}
  eval \${cmd}
done
for mod in "CAPUTRECORDER"; do
  cmd="sed -i s:'^\${mod}=\S*\\$':'\${mod}=\${CAPUTRECORDER_HASH}':g assemble_synApps.sh"
  echo \${cmd}
  eval \${cmd}
done
for mod in "MOTOR"; do
  cmd="sed -i s:'^\${mod}=\S*\\$':'\${mod}=\${MOTOR_HASH}':g assemble_synApps.sh"
  echo \${cmd}
  eval \${cmd}
done
for mod in "STREAM"; do
  cmd="sed -i s:'^\${mod}=\S*\\$':'\${mod}=2.8.14':g assemble_synApps.sh"
  echo \${cmd}
  eval \${cmd}
done

sed -i s:'git submodule update ADSimDetector':'git submodule update ADSimDetector\ngit submodule update ADURL\ngit submodule update pvaDriver':g assemble_synApps.sh
EOF


bash ./.edit_assemble_synApps.sh 2>&1 | tee edit_assemble.log

bash ./assemble_synApps.sh 2>&1 | tee assemble.log

cd ${SUPPORT}

# ADSupport needs to use master branch
pushd ${AREA_DETECTOR}/ADSupport
git checkout master
git pull
# # AREA_DETECTOR, too
# cd ..
# git checkout master
# git pull
popd


cat > ./.edit_area_detector.sh << EOF
#!/bin/bash

# file: recommended_AD_edits.sh
# Purpose: recommended edits:
#    https://areadetector.github.io/master/install_guide.html

pushd ${AREA_DETECTOR}/configure
cp EXAMPLE_RELEASE.local         RELEASE.local
cp EXAMPLE_RELEASE_LIBS.local    RELEASE_LIBS.local
cp EXAMPLE_RELEASE_PRODS.local   RELEASE_PRODS.local
cp EXAMPLE_CONFIG_SITE.local     CONFIG_SITE.local

sed -i s:'SUPPORT=/corvette/home/epics/devel':'SUPPORT=${SUPPORT}':g RELEASE_LIBS.local
sed -i s:'areaDetector-3-10':'areaDetector-${AD_HASH}':g RELEASE_LIBS.local
sed -i s:'asyn-4-41':'asyn-R4-41':g RELEASE_LIBS.local
sed -i s:'EPICS_BASE=/corvette/usr/local/epics-devel/base-7.0.4':'EPICS_BASE=${EPICS_BASE_ROOT}':g RELEASE_LIBS.local

sed -i s:'areaDetector-3-10':'areaDetector-${AD_HASH}':g RELEASE_PRODS.local
sed -i s:'asyn-4-41':'asyn-R4-41':g RELEASE_PRODS.local
sed -i s:'autosave-5-10':'autosave-R5-10-2':g RELEASE_PRODS.local
sed -i s:'busy-1-7-2':'busy-R1-7-3':g RELEASE_PRODS.local
sed -i s:'calc-3-7-3':'calc-R3-7-4':g RELEASE_PRODS.local
sed -i s:'devIocStats-3-1-16':'iocStats-3-1-16':g RELEASE_PRODS.local
sed -i s:'EPICS_BASE=/corvette/usr/local/epics-devel/base-7.0.4':'EPICS_BASE=${EPICS_BASE_ROOT}':g RELEASE_PRODS.local
sed -i s:'seq-2-2-5':'seq-2-2-8':g RELEASE_PRODS.local
sed -i s:'sscan-2-11-3':'sscan-R2-11-4':g RELEASE_PRODS.local
sed -i s:'SUPPORT=/corvette/home/epics/devel':'SUPPORT=${SUPPORT}':g RELEASE_PRODS.local

# CONFIG_SITE.local -- no edits

sed -i s:'#ADSIMDETECTOR=':'ADSIMDETECTOR=':g RELEASE.local
sed -i s:'#ADURL=':'ADURL=':g RELEASE.local
sed -i s:'#PVADRIVER=':'PVADRIVER=':g RELEASE.local
popd

pushd ${AREA_DETECTOR}/ADCore/iocBoot
cp EXAMPLE_commonPlugins.cmd                                commonPlugins.cmd
cp EXAMPLE_commonPlugin_settings.req                        commonPlugin_settings.req
sed -i s:'#NDPvaConfigure':'NDPvaConfigure':g               commonPlugins.cmd
sed -i s:'#dbLoadRecords("NDPva':'dbLoadRecords("NDPva':g   commonPlugins.cmd
sed -i s:'#startPVAServer':'startPVAServer':g               commonPlugins.cmd
popd
EOF


bash ./.edit_area_detector.sh 2>&1 | tee edit_area_detector.log

make -j4 release rebuild 2>&1 | tee build.log
echo "# --- Building XXX IOC ---" 2>&1 | tee -a build.log
make -C ${IOCXXX}/ 2>&1 | tee -a build.log
```

## EPICS GUIs

```sh
sudo apt install -y \
    libxt-dev libxft-dev \
    libmotif-common libmotif-dev \
    libxmu-headers libxmu-dev \
    gitk git-gui

cd ${EPICS_ROOT}
git clone https://github.com/epics-extensions/extensions ./opi
ln -s ./opi extensions

# # tools to discover what package provides libXm.a, needed for MEDM build
# sudo apt install apt-file
# sudo apt-file update
# apt-file search "libXm.a"

cd ./opi
sed -i \
    s:'MOTIF_LIB=/usr/lib64':'MOTIF_LIB=/usr/lib/x86_64-linux-gnu/':g \
    configure/os/CONFIG_SITE.linux-x86_64.linux-x86_64
sed -i \
    s:'X11_LIB=/usr/lib64':'X11_LIB=/usr/lib/x86_64-linux-gnu/':g \
    configure/os/CONFIG_SITE.linux-x86_64.linux-x86_64


cat >> ~/.bash_aliases << EOF
export EPICS_EXT=\${EPICS_ROOT}/opi
export EPICS_EXT_BIN=\${EPICS_EXT}/bin/\${EPICS_HOST_ARCH}
export EPICS_EXT_LIB=\${EPICS_EXT}/lib/\${EPICS_HOST_ARCH}
export PATH=\${PATH}:\${EPICS_EXT_BIN}
EOF
export EPICS_EXT=${EPICS_ROOT}/opi
export EPICS_EXT_BIN=${EPICS_EXT}/bin/${EPICS_HOST_ARCH}
export EPICS_EXT_LIB=${EPICS_EXT}/lib/${EPICS_HOST_ARCH}
export PATH=${PATH}:${EPICS_EXT_BIN}


```

### MEDM

MEDM is available from GitHub.  It needs various out of date packages.
Notably, `libXp` is [now obsolete and not available in modern Ubuntu repositories.](https://askubuntu.com/questions/1318350/i-cannot-find-the-library-libxp-so-6-for-ubuntu-20-04)  Download it from Debian Jessie repository and install by terminal.

```sh
# This command will bring pop-ups that require a human to respond
sudo apt install -y \
    xfonts-traditional \
    xfonts-terminus

cd ${EPICS_EXT}/src
git clone https://github.com/epics-extensions/medm

# libXp not available and can be removed
sed -i \
    s:'USR_LIBS_Linux = Xm Xt Xp Xmu X11 Xext':'USR_LIBS_Linux = Xm Xt Xmu X11 Xext':g \
    medm/medm/Makefile

cd ..
make -j4  2>&1 | tee build.log

# fonts
cd ${EPICS_EXT}
# ! MEDM widget font aliases
# !
# ! add to /usr/X11R6/lib/X11/fonts/misc/fonts.alias
# !     or /usr/share/fonts/X11/misc/fonts.alias
# !
cat > ./medm_fonts.alias << EOF

widgetDM_4 5x7
widgetDM_6 widgetDM_4
widgetDM_8 5x8
widgetDM_10 widgetDM_8
widgetDM_12 6x10
widgetDM_14 6x12
widgetDM_16 7x14
widgetDM_18 widgetDM_16
widgetDM_20 8x16
widgetDM_22 widgetDM_20
widgetDM_24 10x20
widgetDM_30 widgetDM_24
widgetDM_36 12x24
widgetDM_40 widgetDM_36
widgetDM_48 widgetDM_40
widgetDM_60 widgetDM_48
EOF

# run these steps from the root account
sudo su
cp /usr/share/fonts/X11/misc/fonts.alias{,.original}
cat ${EPICS_EXT}/fonts.alias >> /usr/share/fonts/X11/misc/fonts.alias
xset fp rehash
exit
```

### Qt5 library, Qt designer, & Qwt library

Need [Qt](https://wiki.qt.io/Install_Qt_5_on_Ubuntu),
[Qwt](https://qwt.sourceforge.io/qwtinstall.html), and related
libraries.  (Might not need all this but kept growing the list until Qwt
compiled with no errors.)

```sh
sudo apt install -y \
    build-essential \
    libfontconfig1 \
    libglu1-mesa-dev \
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
```

### caQtDM

```sh
cd ${EPICS_EXT}/src

git clone https://github.com/caqtdm/caqtdm.git
cd ./caqtdm/

cat > ./setup_environment.sh << EOF
#!/bin/bash

# usage:  source ./setup_environment.sh

# sets up the shell for building caQtDM
# makes certain that Anaconda Python is not providing Qt to the build

PATH=\${HOME}/bin
PATH+=:/usr/local/sbin
PATH+=:/usr/local/bin
PATH+=:/usr/sbin
PATH+=:/usr/bin
PATH+=:/sbin
PATH+=:/bin
#PATH+=:/usr/games
#PATH+=:/usr/local/games
PATH+=:/usr/local/epics/base/bin/
PATH+=:/usr/local/epics/base/lib/
PATH+=:/usr/local/epics/opi/bin/
PATH+=:/usr/local/epics/base/bin/linux-x86_64
PATH+=:/usr/local/epics/base/lib/linux-x86_64
PATH+=:/usr/local/epics/opi/bin/linux-x86_64
export PATH

export PYTHONVERSION=3.8
export PYTHONINCLUDE=/usr/include/python\${PYTHONVERSION}
export PYTHONLIB=/usr/lib/

export EPICS_BASE=/usr/local/epics/base
export EPICSINCLUDE=\${EPICS_BASE}/include
export EPICSLIB=\${EPICS_BASE}/lib/$EPICS_HOST_ARCH
#export EPICSEXTENSIONS=/usr/local/epics/extensions
export EPICSEXTENSIONS=/usr/local/epics/opi

export QTHOME=/usr
export QWTHOME=/usr
export QWTINCLUDE=/usr/include/qwt
export QWTLIB=\${QWTHOME}/lib/qwt

export QTCONTROLS_LIBS=`pwd`/caQtDM_Binaries
export CAQTDM_COLLECT=`pwd`/caQtDM_Binaries
export QTBASE=\${QTCONTROLS_LIBS}

export QTDM_BININSTALL=\${EPICSEXTENSIONS}/bin/\${EPICS_HOST_ARCH}
export QTDM_LIBINSTALL=\${EPICSEXTENSIONS}/lib/\${EPICS_HOST_ARCH}

mkdir -p \${QTDM_BININSTALL}
mkdir -p \${QTDM_LIBINSTALL}

#export QTDM_RPATH=\${QTDM_LIBINSTALL}:\${QTBASE}
EOF
chmod +x ./setup_environment.sh
source ./setup_environment.sh

# remove manual interaction from shell scripts
sed -i s:'read -p ':'# read -p ':g ./caQtDM_BuildAll
sed -i s:'read -p ':'# read -p ':g ./caQtDM_CleanAll
sed -i s:'read -p ':'# read -p ':g ./caQtDM_Install

sudo apt install -y libpython3.8-dev

bash ./caQtDM_BuildAll 2>&1 | tee -a build.log
bash ./caQtDM_Install 2>&1 | tee -a install.log

cat >> ~/.bash_aliases << EOF
export QT_PLUGIN_PATH=\${EPICS_EXT}/lib/\${EPICS_HOST_ARCH}
EOF
```

## Bluesky

### Docker

```sh
sudo apt-get install -y docker.io
sudo usermod -a -G docker ${USER}

mkdir -p ~/bin
cd ~/bin
url=https://raw.githubusercontent.com/prjemian/epics-docker/master
wget ${url}/n3_synApps/start_xxx.sh
wget ${url}/n4_areaDetector/start_adsim.sh
wget ${url}/n3_synApps/remove_container.sh
chmod +x start_xxx.sh start_adsim.sh remove_container.sh

cat >> ./start_iocs.sh << EOF
~/bin/start_xxx.sh gp
~/bin/start_adsim.sh ad
EOF
chmod +x ./start_iocs.sh
```

### MongoDB

```sh
sudo apt-get install -y mongodb
```

### Python

```sh
mkdir -p ~/Apps
cd ~/Downloads
wget http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -p ~/Apps/miniconda3
source ~/Apps/miniconda3/bin/activate
conda init
```

### Conda environment

```sh
cd ~/Downloads
wget https://raw.githubusercontent.com/BCDA-APS/use_bluesky/main/install/environment_2021_1.yml
conda env create -f ~/Downloads/environment_2021_1.yml
conda env list

cat >> ~/.bash_aliases << EOF
export BLUESKY_ENV=bluesky_2021_1
alias become_bluesky='conda activate \${BLUESKY_ENV}'
EOF
```

### `instrument` package

```sh
cd ~
git clone https://github.com/BCDA-APS/bluesky_instrument_training ./bluesky

mkdir -p ~/.local/share/intake
cat >> ~/.local/share/intake/training.yml << EOF
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
```

Launch the soft IOCs, as needed, when the *instrument* package is started.

```sh
cd ~/bluesky/instrument
mkdir ./iocs
touch ./iocs/__init__.py
cat > ./iocs/check_iocs.py << EOF
"""
check that our EPICS soft IOCs are running
"""

__all__ = []

from ..session_logs import logger

logger.info(__file__)

import epics
import logging
import os

GP_IOC_PREFIX = os.environ.get("GP_IOC_PREFIX", "gp:")

up = epics.caget(f"{GP_IOC_PREFIX}:UPTIME", timeout=1)
if up is None:
    logger.info("EPICS IOCs not running.  Starting them now...")
    start_ioc_script = os.path.join(
        os.environ["HOME"], "bin", "start_iocs.sh",
    )
    os.system(start_ioc_script)
    logger.debug("IOCs started")
else:
    logger.info("EPICS IOCs ready...")
EOF

sed -i s:'import mpl':'import mpl\n\nfrom .iocs import check_iocs':g ./collection.py
```

Configure IPython

```sh
export IPYTHON_DIR=${HOME}/.ipython-bluesky
cat >> ~/.bash_aliases << EOF
export IPYTHON_DIR=${IPYTHON_DIR}
EOF

conda activate ${BLUESKY_ENV}
ipython profile create --ipython-dir=${IPYTHON_DIR} --profile=bluesky
cat > ${IPYTHON_DIR}/profile_bluesky/startup/run_instrument.py << EOF
"start bluesky in IPython session"

import os
import sys
sys.path.append(os.path.join(os.environ["HOME"], "bluesky"))

from instrument.collection import *
EOF
```

Configure starter for this environment.

```sh
cp ~/bluesky/blueskyStarter.sh ~/bin
```

## Reboot

To allow the user account to start the EPICS IOCs in docker, it is necessary
to either logout and log back in again or restart the VM.

```sh
sudo /sbin/shutdown -r now
```
