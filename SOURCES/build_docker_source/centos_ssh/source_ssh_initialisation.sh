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

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

useradd -p eyesofreport -g wheel eyesofreport 2> /dev/null
gpasswd -a eyesofreport wheel 2> /dev/null

ssh_folder=/home/eyesofreport/.ssh

if [ ! -d $ssh_folder ]; then
        mkdir $ssh_folder
fi

file=/home/eyesofreport/.ssh/id_dsa
filename_backup=$(date +'%Y_%m_%d_%s')_id_dsa
filename2_backup=$(date +'%Y_%m_%d_%s')_id_dsa.pub

if [ -f $file ]; then
		echo "DSA Keys already exist for user eyesofreport. Keys are temporary saved in /tmp/$filename_backup and /tmp/$filename2_backup"
        cp $file /tmp/$filename_backup
		cp ${file}.pub /tmp/$filename2_backup
        rm -f $file
		rm -f ${file}.pub
fi

yes | cp -f ${BASEDIR}/id_dsa $ssh_folder/
yes | cp -f ${BASEDIR}/id_dsa.pub $ssh_folder/
chmod 600 ${ssh_folder}/id_dsa
chmod 600 ${ssh_folder}/id_dsa.pub

chown -R eyesofreport:wheel /home/eyesofreport/.ssh

exit

