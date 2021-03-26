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
  - [Bluesky](#bluesky)
    - [Docker](#docker)
    - [MongoDB](#mongodb)
    - [Python](#python)
    - [Conda environment](#conda-environment)
    - [`instrument` package](#instrument-package)

## VirtualBox VM

term | value
:--- | :---
Name | EPICS-Bluesky-Simulator
Type | Linux
Version | Ubuntu (64-bit)
RAM | 2048 MB
Hard disk type | VDI (VirtualBox Disk Image), dynamically allocated
Download URL | https://linuxmint.com/edition.php?id=285
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

TODO: install the VBox Guest Additions then restart (enables resizing
the VM window and can enable copy&paste between VM and host)

* *Devices* menu: *Shared Clipboard*: *Bidirectional*

## First steps after operating system installation

TODO: complete the steps suggested by the welcome wizard

TODO: install the VBox Guest Additions then restart

* Deactivate screen lock from screen saver (since the VM's host policies
  can cover that security aspect)

After installing the Ubuntu-derivative operating, this command updates
the OS from a command-line terminal.  Start such a terminal from the Desktop by the pressing this combination of keys at the same time: `<ctrl><alt>T`

(Use this command any time the OS needs additional update.)

```sh
sudo apt-get update  -y && sudo apt-get upgrade -y
```

## Install Editors

```sh
sudo apt-get install -y nano vim

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
cat >> ~/.bash_aliases << EOF
export EDITOR=nano
EOF
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
```

Install VSCode GUI editor

```sh
cd ~/Downloads/
# FIXME: how to download latest version?
# web browser to https://code.visualstudio.com/#alt-downloads
# and pick linux 64bit .tar.gz
# wget ...url?.../
# example:  code-stable-x64-1615806628.tar.gz
export CODE_ARCHIVE=$(ls -1 code*.gz | sort | tail -1)
cd ~
mkdir -p bin Apps
cd Apps/
tar xzf ~/Downloads/${CODE_ARCHIVE}
cd ../bin
ln -s ../Apps/VSCode-linux-x64/bin/code ./

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
cat >> ~/.bash_aliases << EOF
export PATH=${HOME}/bin:\${PATH}
EOF
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
```

## EPICS base

### Preparation

Next, install packages needed for building EPICS base.  Includes editor tools.

```sh
sudo apt-get install -y \
    apt-utils \
    build-essential \
    libreadline-dev
```

### Environment variables

```sh
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
cat >> ~/.bash_aliases << EOF
export EPICS_ROOT=/usr/local/epics
export EPICS_BASE_NAME=base-7.0.5
export EPICS_HOST_ARCH=linux-x86_64
export EPICS_BASE_ROOT=\${EPICS_ROOT}/\${EPICS_BASE_NAME}
export PATH=\${PATH}:\${EPICS_BASE_ROOT}/bin/\${EPICS_HOST_ARCH}
EOF
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
```

Test the `softIoc` works:

Start the soft IOC: `softIoc -d ~/Documents/demo.db`

```
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

```
epics> dbl
softIoc_demo:longout
softIoc_demo:ao
softIoc_demo:bo
softIoc_demo:stringout
epics>
```

Exit the soft IOC: `exit`

```
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

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
cat >> ~/.bash_aliases << EOF
export SYNAPPS="\${EPICS_ROOT}/synApps"
export SUPPORT="\${SYNAPPS}/support"
export PATH="\${PATH}:\${SUPPORT}/utils"
EOF
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

cd ${EPICS_ROOT}
wget https://raw.githubusercontent.com/EPICS-synApps/support/${HASH}/assemble_synApps.sh

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

bash ./.edit_assemble_synApps.sh 2>&1 | tee edit_assemble.log

bash ./assemble_synApps.sh 2>&1 | tee assemble.log

cd ${SUPPORT}

# ADSupport needs to use master branch
pushd ${AREA_DETECTOR}/ADSupport
git checkout master
git pull
# AREA_DETECTOR, too
cd ..
git checkout master
git pull
popd

make -j4 release rebuild 2>&1 | tee build.log
echo "# --- Building XXX IOC ---" 2>&1 | tee -a build.log
make -C ${IOCXXX}/ 2>&1 | tee -a build.log
```

## EPICS GUIs

## Bluesky

### Docker

```sh
sudo apt-get install -y docker.io
sudo usermod -a -G docker ${USER}
```

### MongoDB

```sh
sudo apt-get install -y mongodb
```

### Python

### Conda environment

### `instrument` package
