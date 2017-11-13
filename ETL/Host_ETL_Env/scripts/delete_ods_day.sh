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

# this script allows to delete data on one day into dtm tables

if [ "$1" == "" ] || [ "$2" == "" ]; then
    echo "Usage : delete_ods_day.sh YYYY_MM_DD YYYY_MM_DD"
else
    echo "I delete dtm table between $1 and $2"
fi

user=eyesofreport
password=SaintThomas,2014
database=eor_ods

echo "DELETE FROM logs WHERE time between '$1' and '$2';" |  mysql --user="$user" --password="$password" --database="$database" 
echo "DELETE FROM logs executed"
