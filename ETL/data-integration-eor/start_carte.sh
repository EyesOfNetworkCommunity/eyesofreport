#!/bin/sh
#########################################
#
# Copyright (C) 2016 EyesOfNetwork Team
# DEV NAME : Benoit Village
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

#myIpAddress=$(ifconfig | tail -n +2 | head -n 1 | awk '{ printf $2 "\n" }' | sed 's/\./\\./g')
#sed -i "s/<hostname>.*<\/hostname>/<hostname>$myIpAddress<\/hostname>/g" /srv/eyesofreport/etl/data-integration/carte_config.xml
/srv/eyesofreport/etl/data-integration/carte.sh /srv/eyesofreport/etl/data-integration/carte_config.xml& > /var/log/pentaho/pentaho.log