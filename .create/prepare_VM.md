# Prepare the Virtual Machine

The entire training system is run from within a Linux virtual machine.
All necessary software will be installed into this VM.

**CONTENTS**

- [Prepare the Virtual Machine](#prepare-the-virtual-machine)
  - [Prerequisites](#prerequisites)
  - [Installation Parameters](#installation-parameters)
  - [Create the VM](#create-the-vm)
    - [Optional](#optional)
    - [Install the VBox Guest Additions](#install-the-vbox-guest-additions)
    - [Restart after Installing Guest Additions](#restart-after-installing-guest-additions)
  - [Prepare the operating system installation](#prepare-the-operating-system-installation)
    - [Remove unused packages](#remove-unused-packages)
    - [Update OS](#update-os)
    - [Prepare account](#prepare-account)

## Prerequisites

You will need:

* [Oracle VM VirtualBox](https://www.virtualbox.org/) software on your host computer
* 2 GB RAM reserved for the training VM to use
* 10 GB hard disk space for the downloaded VM image file (can delete the image once installed)
* 20-40 GB hard disk space for the VM image to use

It is helpful to give the VM image its own CPU core.

## Installation Parameters

Use the same parameters described in the [user installation instructions](../install_vm.md).

Store the user and password in the *Settings*..*Description* as noted.

## Create the VM

1. Add the downloaded ISO file as an optical disk, Live CD/DVD image.
1. Start the new VM.
1. Start the Live installer: `Install Linux Mint` icon on desktop
1. `English`
1. `English (US)` keyboard
1. check the checkbox (`Install multimedia codecs`)
1. `Erase and Install` ... press `[Install Now]` button
1. accept changes to disk (the new VDI disk)
1. Time Zone: Chicago
1. `Who are you?`  see table above

Installation proceeds to completion.

1. Restart Now
2. Press `Enter` key to restart

### Optional

Complete the steps suggested by the welcome wizard

### Install the VBox Guest Additions

1. *Devices* menu: *Insert Guest Additions CD Image*
2. Open the *VBox_GAs...* folder
3. Run `autorun.sh` (if it does not autorun)
4. After that completes, press *Enter* to finish the installation.
5. Right click the CD icon on the Desktop and select *Eject*.
6. *Devices* menu: *Optical Drives*: *Remove disk from virtual drive*
7. *Devices* menu: *Shared Clipboard*: *Bidirectional*
8. *Devices* menu: *Drag and Drop*: *Bidirectional*

- Deactivate screen lock from screen saver (since VM host policies cover that
  security aspect) and change time from 5 minutes to ~30 minutes (or so).

### Restart after Installing Guest Additions

Use the GUI to restart the VM or open a terminal and type:

```sh
sudo /sbin/shutdown -r now
```

Once restarted, relocate & resize the VM window as desired.

## Prepare the operating system installation

### Remove unused packages

To clear unused space from the VM image, delete
LibreOffice and Thunderbird.

```sh
sudo apt remove -y \
    libreoffice-base \
    libreoffice-base-core \
    libreoffice-calc \
    libreoffice-writer \
    libreoffice-core \
    libreoffice-common \
    libreoffice-draw \
    libreoffice-gnome \
    libreoffice-gtk3 \
    libreoffice-help-common \
    libreoffice-impress \
    libreoffice-java-common \
    libreoffice-math \
    libreoffice-style-colibre \
    libreoffice-style-tango \
    libreoffice-writer \
    thunderbird \
    thunderbird-gnome-support
```

It helps to clone these instructions from Github so they can be
executed within the new VM.

```sh
sudo apt install -y git

git clone https://github.com/BCDA-APS/epics-bluesky-vm ~/bluesky
cd ~/bluesky/.create
```

### Update OS

After installing the Ubuntu-derivative operating, this command updates
the OS from a command-line terminal.  Start such a terminal from the
Desktop by the pressing this combination of keys at the same time:
`<ctrl><alt>T`

(Use this command any time the OS needs additional update.)

```sh
sudo apt-get update  -y && sudo apt-get upgrade -y
```

See `./01a_update_os.sh`

### Prepare account

Make sure `~/.bash_aliases` is called from `~/.bashrc`.  Make
sure that `~/bin` exists and is added to `PATH`.

```sh
./01b_setup_account.sh
```
