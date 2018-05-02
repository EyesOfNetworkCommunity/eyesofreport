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
    echo "Usage : generate_data_container.sh source_trigram site trigram"
	echo "	source_trigram : source indentification trigram (e.g. eon for eyesofnetwork)"
	echo "	site_trigram : source indentification trigram (e.g. ma1 for marignane)"
	exit
fi

if [ -z "$2" ]
  then
    echo "Usage : generate_data_container.sh source_trigram site trigram"
	echo "	source_trigram : source indentification trigram (e.g. eon for eyesofnetwork)"
	echo "	site_trigram : source indentification trigram (e.g. ma1 for marignane)"
	exit
fi


BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


source_trigram=$1
site_trigram=$2
source_nagios_path=/srv/eyesofreport/docker_script/centos_nagios_${site_trigram}_${source_trigram}
installation_path=$BASEDIR
log_file=$source_nagios_path/data_container/log_data_container_${site_trigram}_${source_trigram}

mkdir -p $source_nagios_path/data_container

site_source=${site_trigram}_${source_trigram}

cp $installation_path/Dockerfile $source_nagios_path/data_container >> $log_file
cp -r $installation_path/depot $source_nagios_path/data_container >> $log_file
cp $installation_path/generic_data_container.service $source_nagios_path/data_container/${site_source}_data_container.service >> $log_file

echo -e "Environment data_container_${source_trigram} \e[92m[OK] \e[39m"

cd $source_nagios_path/data_container


#customize nagios.service file
nagios_container_service=${site_source}_data_container.service
sed -i "s/container_description/${site_source} data Container/g" ./$nagios_container_service
sed -i "s/container_name/data_container_${site_source}/g" ./$nagios_container_service

cp ./$nagios_container_service /etc/systemd/system

systemctl daemon-reload
systemctl enable ${site_source}_data_container

container_name=data_container_${site_trigram}_${source_trigram}

echo -e "Show container creation log : tail -f /srv/eyesofreport/docker_script/centos_nagios_${site_trigram}_${source_trigram}/data_container/log_data_container_${site_trigram}_${source_trigram}"


docker build -t "$container_name" . >> $log_file

OUT=$?
if [ $OUT -eq 0 ];then
   echo -e "Data container $container_name creation 	\e[92m[OK] \e[39m"
   service ${site_source}_data_container start
else
   echo -e "Data container $container_name creation 	\e[31m[FAILED] \e[39m"
   echo "See logs $source_nagios_path/data_container/log_data_container_${source_trigram} "
   exit 1
fi



exit 0
