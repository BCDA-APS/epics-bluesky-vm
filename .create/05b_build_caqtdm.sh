#!/bin/bash

# file: 05b_build_caqtdm.sh

if [ "" == "${EPICS_EXT}" ]; then
    echo EPICS_ROOT not defined.
    echo perhaps?  source /usr/local/epics/setup_base_env.sh
    echo perhaps?  source /usr/local/epics/setup_extensions_env.sh
    exit 1
fi

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

# pending: https://github.com/caqtdm/caqtdm/issues/56
sed -i s:'caQtDM_Lib.depends += caQtDM_Parsers':'# caQtDM_Lib.depends += caQtDM_Parsers':g ./all.pro

bash ./caQtDM_BuildAll 2>&1 | tee -a build.log
bash ./caQtDM_Install 2>&1 | tee -a install.log

cd ${EPICS_ROOT}
cat > ./setup_caqtdm_env.sh << EOF
# -----------------------------
# file: setup_caqtdm_env.sh
# add to ~/.bash_aliases
export QT_PLUGIN_PATH=\${EPICS_EXT}/lib/\${EPICS_HOST_ARCH}
EOF
chmod +x ./setup_caqtdm_env.sh
