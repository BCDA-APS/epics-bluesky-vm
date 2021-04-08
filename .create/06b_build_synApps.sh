#!/bin/bash

# file: 06b_build_synApps.sh

if [ "" == "${EPICS_ROOT}" ]; then
    echo EPICS_ROOT not defined.
    source /usr/local/epics/setup_base_env.sh
fi

export SUPPORT="${EPICS_ROOT}/synApps/support"
export PATH="${PATH}:${SUPPORT}/utils"

export ENV HASH=R6-2
export MOTOR_HASH=R7-2-2
export AD_HASH=R3-10
export CAPUTRECORDER_HASH=master

export AREA_DETECTOR=${SUPPORT}/areaDetector-${AD_HASH}
export MOTOR=${SUPPORT}/motor-${MOTOR_HASH}
export XXX=${SUPPORT}/xxx-R6-2
export CAPUTRECORDER=${SUPPORT}/caputRecorder-${CAPUTRECORDER_HASH}
export IOCXXX=${XXX}/iocBoot/iocxxx

# env vars for ~/.bash_aliases
cd ${EPICS_ROOT}
cat > ./setup_synApps_env.sh << EOF
# -----------------------------
# file: setup_synApps_env.sh
# add to ~/.bash_aliases
export SUPPORT="\${EPICS_ROOT}/synApps/support"
export PATH="\${PATH}:\${SUPPORT}/utils"
EOF
chmod +x ./setup_synApps_env.sh


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
