# Create the VM

Install EPICS, synApps,GUIs, Bluesky and related components
to create an APS beam line simulator for training, education,
and development related to APS-U.

**CONTENTS**

- [Create the VM](#create-the-vm)
  - [VirtualBox VM](#virtualbox-vm)
  - [EPICS base](#epics-base)
  - [EPICS extensions (OPIs & GUIs)](#epics-extensions-opis--guis)
    - [MEDM](#medm)
    - [caQtDM](#caqtdm)
  - [EPICS synApps](#epics-synapps)
  - [Bluesky Framework](#bluesky-framework)
    - [Docker](#docker)
    - [MongoDB](#mongodb)
    - [Python](#python)
    - [Conda environment](#conda-environment)
    - [`instrument` package](#instrument-package)
  - [Update ~/.bash_aliases](#update-bash_aliases)
  - [Restart after All Installations](#restart-after-all-installations)

## VirtualBox VM

Prepare the virtual machine following this [procedure](./prepare_VM.md).

## EPICS base

Install packages needed for building EPICS base.  Includes editor tools.

```sh
./02a_epics_base_prerequisites.sh
```

Download and build EPICS base:

```sh
sudo mkdir /usr/local/epics
sudo chown ${USER}:${USER} /usr/local/epics

./02b_build_epics_base.sh
```

To test the installation of EPICS base, follow this [procedure](test_EPICS_base.md).

## EPICS extensions (OPIs & GUIs)

The EPICS GUIs (*OPI* by name) are built in the EPICS *extensions*
subdirectory.  These procedures prepare that subdirectory:

```sh
./03a_epics_extensions_prerequisites.sh
source /usr/local/epics/setup_base_env.sh
./03b_setup_epics_extensions.sh
```

### MEDM

MEDM is available from GitHub.  It needs various out of date packages.
Notably, `libXp` is [now obsolete and not available in modern Ubuntu repositories.](https://askubuntu.com/questions/1318350/i-cannot-find-the-library-libxp-so-6-for-ubuntu-20-04)

These procedures download required packages, clone the source code
from GitHub, build the application, and install the necessary font
definitions.

```sh
./04a_medm_prerequisites.sh
```

Answer yes to the two questions that appear during this step.  Then, proceed...

```sh
source /usr/local/epics/setup_extensions_env.sh
./04b_build_medm.sh
./04c_install_medm_fonts.sh
```

### caQtDM

The caQtDM GUI needs [Qt](https://wiki.qt.io/Install_Qt_5_on_Ubuntu),
[Qwt](https://qwt.sourceforge.io/qwtinstall.html), and related
libraries.  (Might not need all this but kept growing the list until Qwt
compiled with no errors.)

```sh
./05a_caqtdm_prerequisites.sh
```

Download the caQtDM source from GitHub, configure, build, and install it.

```sh
./05b_build_caqtdm.sh
```

## EPICS synApps

Download and prepare to build EPICS synApps (might take a minute or two):

```sh
./06a_synApps_prerequisites.sh
```

Build synApps (this step takes 5-20 minutes depending on the workstation):

```sh
./06b_build_synApps.sh
```

## Bluesky Framework

The Bluesky Framework relies on several components to exist
on the same subnet as the bluesky installation.  These include:

* EPICS IOCs to be operated
* database for collected data (using MongoDB)
* Python packages for the Bluesky Framework

For training purposes, we run two EPICS IOCs in
[docker containers](https://www.docker.com/resources/what-container)
so each participant has their own set of the same EPICS PVs.

These two EPICS IOCs comprise a virtual *instrument* to be operated by Bluesky.

### Docker

```sh
./07a_install_docker.sh
```

### MongoDB

The database will be [MongoDB](https://www.mongodb.com/),
installed using this procedure:

```sh
./08a_install_mongodb.sh
```

### Python

We avoid modifying the Python installations provided by the operating system since they require certain package versions to operate properly.  Instead,
add a Python installation that we can customize, using
[Miniconda](https://docs.conda.io/en/latest/miniconda.html)

```sh
./09a_install_miniconda.sh
```

### Conda environment

Install the Bluesky Framework into a [custom conda 
environment](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html).  This
will make package updates much simpler, espcially when the entire framework 
needs a periodic refresh.

```sh
./09b_create_conda_environment.sh
```

### `instrument` package

Install the Bluesky code that talks with the virtual *instrument*:

```sh
./09c_install_instrument_package.sh
```

Configure IPython (the interactive console Python session to be used).

```sh
./09d_configure_ipython.sh
```

## Update ~/.bash_aliases

Gather all the environment setup scripts and add their contents 
to `~/.bash_aliases`:

```sh
./09e_setup_bash_aliases.sh
```


## Restart after All Installations

To allow the user account to start the EPICS IOCs in docker, it is necessary
to either logout and log back in again or restart the VM.

```sh
sudo /sbin/shutdown -r now
```
