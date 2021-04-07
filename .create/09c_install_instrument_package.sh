#!/bin/bash

# file: 09c_install_instrument_package.sh

cd ~
# git clone https://github.com/BCDA-APS/bluesky_instrument_training ./bluesky

export BLUESKY_CATALOG_DIR=~/.local/share/intake
export INST=~/bluesky/instrument

mkdir -p ${BLUESKY_CATALOG_DIR}
cat >> ${BLUESKY_CATALOG_DIR}/training.yml << EOF
# - - - - - - - - - - - - - - - -
# file: training.yml
# purpose: Configuration file to connect Bluesky databroker with MongoDB
# For Bluesky Python Training at APS

# Copy to: ~/.local/share/intake/training.yml
# Create subdirectories as needed

sources:
  training:
    args:
      asset_registry_db: mongodb://localhost:27017/training-bluesky
      metadatastore_db: mongodb://localhost:27017/training-bluesky
    driver: bluesky-mongo-normalized-catalog
EOF

sed -i s:'class_2021_03':'training':g ${INST}/framework/initialize.py

# Configure starter for this environment.
# sed -i s:'=class_2021_03':'=bluesky_2021_1':g ~/bluesky/blueskyStarter.sh
ln -s ~/bluesky/blueskyStarter.sh ~/bin/blueskyStarter.sh

# # ensure that IOCs are started when instrument package is imported
# sed -i s:'import mpl':'import mpl\nfrom .iocs.check_iocs import *':g ${INST}/collection.py
# export IOCS=${INST}/iocs
# mkdir ${IOCS}
# touch ${IOCS}/__init__.py

# cat > ${IOCS}/check_iocs.py << EOF
# """
# check that our EPICS soft IOCs are running
# """

# from ..session_logs import logger
# logger.info(__file__)

# import epics
# import os
# import subprocess

# GP_IOC_PREFIX = os.environ.get("GP_IOC_PREFIX", "gp:")

# def run_command(command):
#     with subprocess.Popen(command,
#                           stdout=subprocess.PIPE,
#                           stderr=subprocess.PIPE,
#     ) as process:
#         outs, errs = process.communicate()
#         if len(outs.strip()) > 0:
#             logger.info(outs.strip().decode())
#         if len(errs.strip()) > 0:
#             logger.error(errs.strip().decode())

# up = epics.caget(f"{GP_IOC_PREFIX}:UPTIME", timeout=1)
# if up is None:
#     home = os.environ["HOME"]
#     logger.info(
#       "EPICS %s IOC not running.  Starting now...",
#       GP_IOC_PREFIX
#     )
#     run_command(f"{home}/bin/start_iocs.sh")
#     logger.debug("IOCs started")
# else:
#     logger.info("EPICS IOCs ready...")

# up = epics.caget("IOC:float1.NAME", timeout=1)
# if up is None:
#     logger.info("EPICS registers IOC not running.  Starting now...")
#     path = os.path.abspath(os.path.dirname(__file__))
#     run_command(os.path.join(path, "in_screen.sh"))
#     logger.debug(f"registers IOC started")
#     run_command("screen -ls".split())
# else:
#     logger.info("EPICS registers IOC ready...")
# EOF

# cat > ${IOCS}/in_screen.sh << EOF
# #!/bin/bash
# # file: in_screen.sh
# export BASE=\$(dirname $0)
# /usr/bin/screen -d -m -S IOC_registers -h 5000 ${BASE}/run_ioc.sh
# echo \$(screen -ls)
# EOF
# chmod +x ${IOCS}/in_screen.sh

# cat > ${IOCS}/registers.db << EOF

# # file: registers.db
# #
# # purpose: R/W IOC variables for general use
# # usage:   softIoc -d registers.db

# record(ao, "IOC:float1")
# record(ao, "IOC:float2")
# record(ao, "IOC:float3")
# record(ao, "IOC:float4")
# record(ao, "IOC:float5")

# record(bo, "IOC:bit1")
# record(bo, "IOC:bit2")
# record(bo, "IOC:bit3")
# record(bo, "IOC:bit4")
# record(bo, "IOC:bit5")

# record(longout, "IOC:int1")
# record(longout, "IOC:int2")
# record(longout, "IOC:int3")
# record(longout, "IOC:int4")
# record(longout, "IOC:int5")

# record(stringout, "IOC:text1")
# record(stringout, "IOC:text2")
# record(stringout, "IOC:text3")
# record(stringout, "IOC:text4")
# record(stringout, "IOC:text5")

# record(waveform, "IOC:textwave1") {
#   field(DTYP, "Soft Channel")
#   field(NELM, "2048")
#   field(FTVL, "CHAR")
# }
# record(waveform, "IOC:textwave2") {
#   field(DTYP, "Soft Channel")
#   field(NELM, "2048")
#   field(FTVL, "CHAR")
# }
# record(waveform, "IOC:textwave3") {
#   field(DTYP, "Soft Channel")
#   field(NELM, "2048")
#   field(FTVL, "CHAR")
# }
# record(waveform, "IOC:textwave4") {
#   field(DTYP, "Soft Channel")
#   field(NELM, "2048")
#   field(FTVL, "CHAR")
# }
# record(waveform, "IOC:textwave5") {
#   field(DTYP, "Soft Channel")
#   field(NELM, "2048")
#   field(FTVL, "CHAR")
# }
# EOF

# cat > ${IOCS}/run_ioc.sh << EOF
# #!/bin/bash
# # file: run_ioc.sh

# export BASE=\$(dirname $0)
# export SOFT_IOC=\$(which softIoc)

# \${SOFT_IOC} -d \${BASE}/registers.db
# EOF
# chmod +x ${IOCS}/run_ioc.sh

# cat > ${IOCS}/test.db << EOF
# # file: test.db
# # purpose: test bluesky/ophyd put & get with waveform record
# #
# # start IOC:   softIoc -d test.db

# record(waveform, "string_waveform") {
#   field(DTYP, "Soft Channel")
#   field(NELM, "256")
#   field(FTVL, "CHAR")
# }
# EOF
