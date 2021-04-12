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

cp ~/bluesky/.create/start_iocs.sh ~/bin
./start_iocs.sh

ln -s /tmp/docker_ioc/iocad/iocSimDetector/start_caQtDM_adsim ~/bin/start_caQtDM_ad
ln -s ${HOME}/bluesky/.create/start_MEDM_ad ~/bin/start_MEDM_ad

ln -s /tmp/docker_ioc/iocgp/xxx-R6-1/start_caQtDM_xxx ~/bin/start_caQtDM_gp
ln -s /tmp/docker_ioc/iocgp/xxx-R6-1/start_MEDM_xxx ~/bin/start_MEDM_gp

# install cron job
cp ~/bluesky/.create/ioc_manager.sh ~/bin
(crontab -l; echo "";) | crontab -
(crontab -l; echo "# auto-start the EPICS soft IOCs in docker containers";) | crontab -
(crontab -l; echo "*/2 * * * *  bash ${HOME}/bin/ioc_manager.sh checkup 2>&1 > /dev/null";) | crontab -
