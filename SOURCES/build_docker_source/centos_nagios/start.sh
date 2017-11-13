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

trigram=$2
for file in `docker ps | grep $1`; do
	echo -e "container $1 already up 	\e[92m[STARTED] \e[39m"
	exit
done

for file in `docker ps -a | grep $1`; do
	echo "container $1 exist : starting..."
        docker start $1
	echo -e "container $1		\e[92m[STARTED] \e[39m"
	exit
done

docker run -d --name $1 --privileged -v /srv/eyesofreport/source/$2/Log_Nagios/:/srv/eyesofnetwork/nagios/var/log/archives -v /srv/eyesofreport/source/$2:/srv/eyesofreport/external_depot -v /srv/eyesofreport/scripts:/srv/eyesofreport/scripts -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v /var/lib/mysql/mysql.sock:/var/lib/mysql/mysql.sock:ro $1
