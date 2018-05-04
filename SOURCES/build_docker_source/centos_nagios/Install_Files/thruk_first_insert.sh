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

tail -n +3 /tmp/thruk_backend_2

livestatus_prefix=$(awk '{ print $2; }' /tmp/thruk_backend_2)

echo "$livestatus_prefix"

./thruk -a logcacheupdate --local /srv/eyesofnetwork/nagios/var/log/archives/nagios-*.log -b "$livestatus_prefix"
rm -rf /tmp/thruk_backend
rm -rf /tmp/thruk_backend_2
