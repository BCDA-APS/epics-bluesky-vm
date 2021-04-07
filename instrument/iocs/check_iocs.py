"""
check that our EPICS soft IOCs are running
"""

from ..session_logs import logger
logger.info(__file__)

import epics
import os
import subprocess

GP_IOC_PREFIX = os.environ.get("GP_IOC_PREFIX", "gp:")

def run_command(command):
    with subprocess.Popen(command,
                          stdout=subprocess.PIPE,
                          stderr=subprocess.PIPE,
    ) as process:
        outs, errs = process.communicate()
        if len(outs.strip()) > 0:
            logger.info(outs.strip().decode())
        if len(errs.strip()) > 0:
            logger.error(errs.strip().decode())

up = epics.caget(f"{GP_IOC_PREFIX}:UPTIME", timeout=1)
if up is None:
    home = os.environ["HOME"]
    logger.info("EPICS IOCs not running.  Starting them now...")
    run_command(f"{home}/bin/start_iocs.sh")
    logger.debug("EPICS IOCs started")
else:
    logger.info("EPICS IOCs ready...")

up = epics.caget("IOC:float1.NAME", timeout=1)
if up is None:
    logger.info("EPICS registers IOC not running.  Starting now...")
    path = os.path.abspath(os.path.dirname(__file__))
    run_command(os.path.join(path, "in_screen.sh"))
    logger.debug(f"registers IOC started")
    run_command("screen -ls".split())
else:
    logger.info("EPICS registers IOC ready...")
