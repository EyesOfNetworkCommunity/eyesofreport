#!/bin/bash
#########################################
#
# Copyright (C) 2016 EyesOfNetwork Team
# DEV NAME : Benoit Village Jan 2016
# 
# VERSION 2.01
# 
# LICENCE :
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
#########################################

if [ -z "$1" ]
  then
    echo "Usage : generate_ssh_container.sh source_trigram site trigram ssh_port"
	echo "	source_trigram : source indentification trigram (e.g. eon for eyesofnetwork)"
	echo "	site_trigram : source indentification trigram (e.g. ma1 for marignane)"
	echo "	ssh_port : port on which ssh will be open in container"
	exit
fi

if [ -z "$2" ]
  then
    echo "Usage : generate_ssh_container.sh source_trigram site trigram ssh_port"
	echo "	source_trigram : source indentification trigram (e.g. eon for eyesofnetwork)"
	echo "	site_trigram : source indentification trigram (e.g. ma1 for marignane)"
	echo "	ssh_port : port on which ssh will be open in container"
	exit
fi

if [ -z "$3" ]
  then
    echo "Usage : generate_ssh_container.sh source_trigram site trigram ssh_port"
	echo "	source_trigram : source indentification trigram (e.g. eon for eyesofnetwork)"
	echo "	site_trigram : source indentification trigram (e.g. ma1 for marignane)"
	echo "	ssh_port : port on which ssh will be open in container"
	exit
fi

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ ! -f "${BASEDIR}/id_dsa.pub" ]
  then
    echo "Usage : You must place in centos_ssh folder id_dsa.pub file which contains ssh user public key generated on log nagios sender host"
	exit
fi

source_trigram=$1
site_trigram=$2
ssh_port=$3
source_nagios_path=/srv/eyesofreport/docker_script/centos_nagios_${site_trigram}_${source_trigram}
installation_path=$BASEDIR
log_file=$source_nagios_path/centos_ssh/log_centos_ssh_${site_trigram}_${source_trigram}

mkdir -p $source_nagios_path/centos_ssh

site_source=${site_trigram}_${source_trigram}

cd $installation_path/Install_Files
tar cvf ./Install_Files.tar ./* >> $log_file
mv ./Install_Files.tar $installation_path

cp $installation_path/Dockerfile $source_nagios_path/centos_ssh >> $log_file
cp $installation_path/generate_ssh_container.sh $source_nagios_path/centos_ssh >> $log_file
cp $installation_path/start.sh $source_nagios_path/centos_ssh/start_ssh_${site_source}.sh >> $log_file
mv $installation_path/id_dsa.pub $source_nagios_path/centos_ssh >> $log_file
cp $installation_path/Install_Files.tar $source_nagios_path/centos_ssh >> $log_file
cp $installation_path/generic_ssh_docker.service $source_nagios_path/centos_ssh/${site_source}_ssh_container.service >> $log_file

rm -f $installation_path/Install_Files.tar

echo -e "Environment centos_ssh_${source_trigram} \e[92m[OK] \e[39m"

cd $source_nagios_path/centos_ssh

replace "/" "\/" -- ./id_dsa.pub >> $log_file
 
public_key=$(<id_dsa.pub) >> $log_file

sed -i "s/public_key/$public_key/g" ./Dockerfile >> $log_file
sed -i "s/ssh_port/$ssh_port/g" ./Dockerfile >> $log_file

replace "\\" "" -- id_dsa.pub >> $log_file



#customize nagios.service file
nagios_container_service=${site_source}_ssh_container.service
sed -i "s/container_description/${site_source} SSH Container/g" ./$nagios_container_service
sed -i "s/container_folder/centos_nagios_${site_source}/g" ./$nagios_container_service
sed -i "s/start_file/start_ssh_${site_source}/g" ./$nagios_container_service
sed -i "s/container_name/centos_ssh_${site_source}/g" ./$nagios_container_service
sed -i "s/\$2/$ssh_port/g" ./$nagios_container_service
sed -i "s/\$3/$site_source/g" ./$nagios_container_service
sed -i "s/--volumes-from ssh_data/--volumes-from data_container_${site_source}/g" ./$nagios_container_service

cp ./$nagios_container_service /etc/systemd/system

systemctl daemon-reload
systemctl enable ${site_source}_ssh_container.service

container_name=centos_ssh_${site_trigram}_${source_trigram}

sed -i "s/\$1/$container_name/g" ./start_ssh_${site_trigram}_${source_trigram}.sh
sed -i "s/\$2/$ssh_port/g" ./start_ssh_${site_trigram}_${source_trigram}.sh

echo -e "Show container creation log : tail -f /srv/eyesofreport/docker_script/centos_nagios_${site_trigram}_${source_trigram}/centos_ssh/log_centos_ssh_${site_trigram}_${source_trigram}"


docker build -t "$container_name" . >> $log_file

OUT=$?
if [ $OUT -eq 0 ];then
   echo -e "SSH container $container_name creation 	\e[92m[OK] \e[39m"
   service ${site_source}_ssh_container start
else
   echo -e "SSH container $container_name creation 	\e[31m[FAILED] \e[39m"
   echo "See logs $source_nagios_path/centos_ssh/log_centos_ssh_${source_trigram} "
   exit 1
fi



exit 0
