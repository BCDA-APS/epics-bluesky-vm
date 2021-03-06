"""
simulated noisy temperature controller using swait record
"""

__all__ = [
    "temperature",
]

from ..session_logs import logger

logger.info(__file__)

from .calculation_records import calcs
from apstools.synApps import SwaitRecord
from ophyd import Component
from ophyd import EpicsSignal
from ophyd import EpicsSignalRO
from ophyd import PVPositioner
from ophyd import Signal
import numpy as np
import os

GP_IOC_PREFIX = os.environ.get("GP_IOC_PREFIX", "gp:")


class MyPvPositioner(PVPositioner):
    # positioner
    setpoint = Component(EpicsSignal, ".B", kind="hinted")
    readback = Component(EpicsSignal, ".VAL", kind="hinted")  # THIS readback IS writable!
    done = Component(Signal, value=True, kind="omitted")
    done_value = True

    # additional, for the simulator
    calculation = Component(EpicsSignal, ".CALC", kind="config")
    description = Component(EpicsSignal, ".DESC", kind="config")
    max_change = Component(EpicsSignal, ".D", kind="config")
    noise = Component(EpicsSignal, ".C", kind="config")
    previous_value_pv = Component(EpicsSignal, ".INAN", kind="config")
    scanning_rate = Component(EpicsSignal, ".SCAN", kind="config")
    tolerance = Component(EpicsSignal, ".E", kind="config")
    report_dmov_changes = Component(Signal, value=True, kind="omitted")

    def cb_readback(self, *args, **kwargs):
        """
        Called when readback changes (EPICS CA monitor event).
        """
        diff = self.readback.get() - self.setpoint.get()
        dmov = abs(diff) <= self.tolerance.get()
        if self.report_dmov_changes.get() and dmov != self.done.get():
            logger.debug(f"{self.name} reached: {dmov}")
        self.done.put(dmov)

    def cb_setpoint(self, *args, **kwargs):
        """
        Called when setpoint changes (EPICS CA monitor event).

        When the setpoint is changed, force done=False.  For any move, 
        done must go != done_value, then back to done_value (True).
        Without this response, a small move (within tolerance) will not return.
        Next update of readback will compute self.done.
        """
        self.done.put(not self.done_value)

    def __init__(
        self,
        prefix,
        *,
        limits=None,
        name=None,
        read_attrs=None,
        configuration_attrs=None,
        parent=None,
        egu="",
        **kwargs,
    ):
        super().__init__(
            prefix=prefix,
            limits=limits,
            name=name,
            read_attrs=read_attrs,
            configuration_attrs=configuration_attrs,
            parent=parent,
            egu=egu,
            **kwargs,
        )
        self.readback.subscribe(self.cb_readback)
        self.setpoint.subscribe(self.cb_setpoint)

        # Make the default alias for the readback the name of the device itself.
        self.readback.name = self.name

    def setup_temperature(
        self,
        setpoint=None,
        noise=2,
        rate=6,
        tol=1,
        max_change=2,
        report_dmov_changes=True,
    ):
        """
        Setup the swait record with new random numbers.

        BLOCKING calls, not a bluesky plan
        """
        calcs.calc8.reset()  # remove any prior configuration
        self.description.put("temperature")
        self.report_dmov_changes.put(report_dmov_changes)
        self.previous_value_pv.put(self.readback.pvname)
        if setpoint is not None:
            self.setpoint.put(setpoint)
            self.readback.put(setpoint)
        self.noise.put(noise)
        self.max_change.put(max_change)
        self.tolerance.put(tol)
        self.scanning_rate.put(rate)  # 1 second
        self.calculation.put("A+max(-D,min(D,(B-A)))+C*(RNDM-0.5)")


temperature = MyPvPositioner(
    f"{GP_IOC_PREFIX}userCalc8", name="temperature", limits=(-20, 255), egu="C",
)
temperature.wait_for_connection()
temperature.setup_temperature(
    setpoint=25, noise=1, rate=5, tol=1, max_change=2, report_dmov_changes=False
)
