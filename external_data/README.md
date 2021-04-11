# example-data

*APS Training for Bluesky Data Acquisition*.

**Objective**

* Extract data from a Bluesky data collection database.
* Use that data from a different workstation.

- [example-data](#example-data)
  - [Pack: Extract measurements from the `databroker`](#pack-extract-measurements-from-the-databroker)
  - [Copy the archive file locally](#copy-the-archive-file-locally)
  - [Load the data with databroker](#load-the-data-with-databroker)

## Pack: Extract measurements from the `databroker`

Previously, we collected a variety of measurements (bluesky *runs*)
using our simulated instrument. Follow the [instructions to
pack](./external_data/README.md) that data into an archive file.

## Copy the archive file locally

Given the archive file, `class_data_examples.zip`, copy it locally
and configure databroker to use provide the runs.  Follow
the [*unpack* notebook](https://nbviewer.jupyter.org/github/BCDA-APS/epics-bluesky-vm/blob/main/external_data/unpack.ipynb).

NOTE: If you need to run this notebook again, you must **first** delete these files and directories:

* `/home/apsu/.local/share/intake/databroker_unpack_class_data_examples.yml`
* `/home/apsu/data/class_data_examples/`

## Load the data with databroker

Start an ipython console session or Jupyter lab notebook.  We'll
demonstrate with the [`image_analysis.ipynb`](./image_analysis.ipynb) 
[notebook](https://nbviewer.jupyter.org/github/BCDA-APS/epics-bluesky-vm/blob/main/external_data/image_analysis.ipynb).
