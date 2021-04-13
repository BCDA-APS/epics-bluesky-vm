"""
example scaler
"""

__all__ = """
    scaler1
    timebase I0 scint diode
""".split()

from ..session_logs import logger

logger.info(__file__)

from ophyd import Kind
from ophyd.scaler import ScalerCH
import os
import time

GP_IOC_PREFIX = os.environ.get("GP_IOC_PREFIX", "gp:")

# make an instance of the entire scaler, for general control
scaler1 = ScalerCH(f"{GP_IOC_PREFIX}scaler1", name="scaler1", labels=["scalers", "detectors"])
scaler1.wait_for_connection()

# CAUTION: CUSTOM CODE FOR THIS SIMULATOR ONLY
# define channel names JUST for this simulation.
# For a real instrument, the names are assigned when the 
# detector pulse cables are connected to the scaler channels.
_counters = dict(
    timebase=scaler1.channels.chan01,
    I0=scaler1.channels.chan02,
    scint=scaler1.channels.chan03,
    diode=scaler1.channels.chan04,
    I00=scaler1.channels.chan05,
    roi1=scaler1.channels.chan11,
    roi2=scaler1.channels.chan12,
)
for k, v in _counters.items():
    if not len(v.chname.get().strip()):
        logger.info("Assigning %s to '%s'", v.name, k)
        v.chname.put(k)

# choose just the channels with EPICS names
time.sleep(1)  # wait for IOC
scaler1.select_channels()

# examples: make shortcuts to specific channels assigned in EPICS

timebase = _counters["timebase"].s
I0 = _counters["I0"].s
I00 = _counters["I00"].s
scint = _counters["scint"].s
diode = _counters["diode"].s
roi1 = _counters["roi1"].s
roi2 = _counters["roi2"].s

for item in (timebase, I0, I00, scint, diode, roi1, roi2):
    item._ophyd_labels_ = set(["channel", "counter",])
