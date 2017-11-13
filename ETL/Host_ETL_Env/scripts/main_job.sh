#########################################
#
# Copyright (C) 2016 EyesOfNetwork Team
# DEV NAME : # Michael Aubertin Nov 2014 & Benoit Village Jan 2016
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

extractbeg=$(date --date="$(date +%Y-%m-%d --date="yesterday")"  +%s)
extractend=$(($(date --date="$(date +%Y-%m-%d --date="yesterday")"  +%s) + 86399))
/srv/eyesofreport/etl/data-integration/kitchen.sh -rep=eor_repository -user=admin -pass=admin -dir=/Alimentation -job=JOB_MAIN -param:extractbeg=$extractbeg -param:extractend=$extractend
#cd /srv/eyesofreport/etl/scripts/
#wget "http://cluster:root66@localhost:8181/kettle/runJob/?job=/Alimentation/JOB_MAIN&extractbeg=$extractbeg&extractend=$extractend" > /dev/null
#yes | rm /srv/eyesofreport/etl/scripts/index*
