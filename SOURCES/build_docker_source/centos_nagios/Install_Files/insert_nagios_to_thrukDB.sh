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

cd /srv/eyesofnetwork/thruk/script
./thruk -l > /tmp/thruk_backend
tail -n +3 /tmp/thruk_backend > /tmp/thruk_backend_2

SystemNagiosID="source_eon"
UniqLiveStatusID=$(awk '{ print $2; }' /tmp/thruk_backend_2)

rm /tmp/thruk_backend
rm /tmp/thruk_backend_2


if [ ! -d /srv/eyesofnetwork/nagios/var/log/archives/ ]; then
        echo "Cannot continue. Configuration required. Please refer to SPEC book."
        exit
fi

if [ -n "`find /srv/eyesofnetwork/nagios/var/log/archives/ -type f -name nagios-*.log -exec echo {} \;`" ]; then
        echo "je trouve bien un fichier dans /srv/eyesofreport/source/${SystemNagiosID}/Archives/"
        cd /srv/eyesofnetwork/thruk/script/
        for file in `ls /srv/eyesofnetwork/nagios/var/log/archives/nagios-*.log`; do
                ./thruk -a logcacheupdate --local $file -b ${UniqLiveStatusID}
                ./thruk -a logcacheoptimize --local
        done
        cd -

         mv /srv/eyesofnetwork/nagios/var/log/archives/nagios-*.log /srv/eyesofreport/external_depot/Archives/
fi

if [ -n "`find /srv/eyesofreport/external_depot/Archives/ -type f -name nagios-*.log -exec echo {} \;`" ]; then
        for file in `ls /srv/eyesofreport/external_depot/Archives/nagios-*.log`; do
                gzip -f $file
        done
fi
