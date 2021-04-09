#!/bin/bash

# file: all_steps

# Note that the password will be requested occasionally.

# First steps run when setting up the VM.
# ./01a_update_os.sh
# ./01b_setup_account.sh

# Full installation of the software stack.
./02a_epics_base_prerequisites.sh
./02b_build_epics_base.sh
./03a_epics_extensions_prerequisites.sh
./03b_setup_epics_extensions.sh
./04a_medm_prerequisites.sh
./04b_build_medm.sh
./04c_install_medm_fonts.sh
./05a_caqtdm_prerequisites.sh
./05b_build_caqtdm.sh
./06a_synApps_prerequisites.sh
./06b_build_synApps.sh
./07a_install_docker.sh
./08a_install_mongodb.sh
./09a_install_miniconda.sh
./09b_create_conda_environment.sh
./09c_install_instrument_package.sh
./09d_configure_ipython.sh
./09e_setup_bash_aliases.sh

echo Restart the VM to begin testing Bluesky, et al.
