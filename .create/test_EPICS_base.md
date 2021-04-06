# Test EPICS base installation

TODO: need the environment scripts

## test EPICS base installation

First, use this test database for EPICS ([`demo.db`](.demo.db)).  (Download
and save it to `~/Documents/demo.db`.)  This database file describes
the PVs to test.

Test the `softIoc` works:

Start the soft IOC: `softIoc -d ~/Documents/demo.db`

```sh
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

```sh
epics> dbl
softIoc_demo:longout
softIoc_demo:ao
softIoc_demo:bo
softIoc_demo:stringout
epics>
```

Exit the soft IOC: `exit`

```sh
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
