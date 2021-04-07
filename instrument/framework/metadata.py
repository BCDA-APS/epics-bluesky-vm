"""
define standard experiment metadata
"""

__all__ = []

from ..session_logs import logger

logger.info(__file__)

import apstools
import bluesky
import databroker
from datetime import datetime
import epics
import getpass
import h5py
import intake
import matplotlib
import numpy
import ophyd
import os
import pyRestTable
import socket
import spec2nexus

from .initialize import RE

# Set up default metadata
now = datetime.now()
RE.md["beamline_id"] = f"APS EPICS/Python/Bluesky training VM"
RE.md["instrument_name"] = f"training"
RE.md["proposal_id"] = f"training-{now.year}-{now.month:02d}"
RE.md["pid"] = os.getpid()

HOSTNAME = socket.gethostname() or "localhost"
USERNAME = getpass.getuser() or "APS lesson user"
RE.md["login_id"] = USERNAME + "@" + HOSTNAME

# useful diagnostic to record with all data
versions = dict(
    apstools=apstools.__version__,
    bluesky=bluesky.__version__,
    databroker=databroker.__version__,
    epics=epics.__version__,
    h5py=h5py.__version__,
    intake=intake.__version__,
    matplotlib=matplotlib.__version__,
    numpy=numpy.__version__,
    ophyd=ophyd.__version__,
    pyRestTable=pyRestTable.__version__,
    spec2nexus=spec2nexus.__version__,
)
RE.md["versions"] = versions
