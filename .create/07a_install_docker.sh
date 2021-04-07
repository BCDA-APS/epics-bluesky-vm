#!/bin/bash

# file: 07a_install_docker.sh

sudo apt-get install -y docker.io
sudo usermod -a -G docker ${USER}

cd ~/bin
url=https://raw.githubusercontent.com/prjemian/epics-docker/master
wget ${url}/n3_synApps/start_xxx.sh
wget ${url}/n4_areaDetector/start_adsim.sh
wget ${url}/n3_synApps/remove_container.sh
chmod +x start_xxx.sh start_adsim.sh remove_container.sh

cat >> ./start_iocs.sh << EOF
#!/bin/sh
# start the EPICS soft IOCs
#
#  gp : general purpose IOC - motors, scaler, calcs, sscans, ...
#  ad : ADSimDetector - simulated 2-D area detector, 1k x 1k
~/bin/start_xxx.sh gp
~/bin/start_adsim.sh ad
EOF
chmod +x ./start_iocs.sh
