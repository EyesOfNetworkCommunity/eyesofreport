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

EOR_TECHNIC_DATABASE_IP=$(echo $EOR_TECHNIC_DATABASE_IP | sed -e 's/\\/\\\\/g' -e 's/\./\\./g' -e 's/\//\\\//g' -e 's/\$/\\$/g' -e 's/\*/\\*/g' -e 's/\[/\\[/g' -e 's/\]/\\]/g' -e 's/\^/\\^/g')
EOR_TECHNIC_DATABASE_USER=$(echo $EOR_TECHNIC_DATABASE_USER | sed -e 's/\\/\\\\/g' -e 's/\./\\./g' -e 's/\//\\\//g' -e 's/\$/\\$/g' -e 's/\*/\\*/g' -e 's/\[/\\[/g' -e 's/\]/\\]/g' -e 's/\^/\\^/g')
EOR_TECHNIC_DATABASE_PWD=$(echo $EOR_TECHNIC_DATABASE_PWD | sed -e 's/\\/\\\\/g' -e 's/\./\\./g' -e 's/\//\\\//g' -e 's/\$/\\$/g' -e 's/\*/\\*/g' -e 's/\[/\\[/g' -e 's/\]/\\]/g' -e 's/\^/\\^/g')

EOR_WEB_DATABASE_IP=$(echo $EOR_WEB_DATABASE_IP | sed -e 's/\\/\\\\/g' -e 's/\./\\./g' -e 's/\//\\\//g' -e 's/\$/\\$/g' -e 's/\*/\\*/g' -e 's/\[/\\[/g' -e 's/\]/\\]/g' -e 's/\^/\\^/g')
EOR_WEB_DATABASE_USER=$(echo $EOR_WEB_DATABASE_USER | sed -e 's/\\/\\\\/g' -e 's/\./\\./g' -e 's/\//\\\//g' -e 's/\$/\\$/g' -e 's/\*/\\*/g' -e 's/\[/\\[/g' -e 's/\]/\\]/g' -e 's/\^/\\^/g')
EOR_WEB_DATABASE_PWD=$(echo $EOR_WEB_DATABASE_PWD | sed -e 's/\\/\\\\/g' -e 's/\./\\./g' -e 's/\//\\\//g' -e 's/\$/\\$/g' -e 's/\*/\\*/g' -e 's/\[/\\[/g' -e 's/\]/\\]/g' -e 's/\^/\\^/g')

EOR_DATABASE_IP=$(echo $EOR_DATABASE_IP | sed -e 's/\\/\\\\/g' -e 's/\./\\./g' -e 's/\//\\\//g' -e 's/\$/\\$/g' -e 's/\*/\\*/g' -e 's/\[/\\[/g' -e 's/\]/\\]/g' -e 's/\^/\\^/g')
EOR_DATABASE_USER=$(echo $EOR_DATABASE_USER | sed -e 's/\\/\\\\/g' -e 's/\./\\./g' -e 's/\//\\\//g' -e 's/\$/\\$/g' -e 's/\*/\\*/g' -e 's/\[/\\[/g' -e 's/\]/\\]/g' -e 's/\^/\\^/g')
EOR_DATABASE_PWD=$(echo $EOR_DATABASE_PWD | sed -e 's/\\/\\\\/g' -e 's/\./\\./g' -e 's/\//\\\//g' -e 's/\$/\\$/g' -e 's/\*/\\*/g' -e 's/\[/\\[/g' -e 's/\]/\\]/g' -e 's/\^/\\^/g')

EOR_REPOSITORY_IP=$(echo $EOR_REPOSITORY_IP | sed -e 's/\\/\\\\/g' -e 's/\./\\./g' -e 's/\//\\\//g' -e 's/\$/\\$/g' -e 's/\*/\\*/g' -e 's/\[/\\[/g' -e 's/\]/\\]/g' -e 's/\^/\\^/g')
EOR_REPOSITORY_USER=$(echo $EOR_REPOSITORY_USER | sed -e 's/\\/\\\\/g' -e 's/\./\\./g' -e 's/\//\\\//g' -e 's/\$/\\$/g' -e 's/\*/\\*/g' -e 's/\[/\\[/g' -e 's/\]/\\]/g' -e 's/\^/\\^/g')
EOR_REPOSITORY_PWD=$(echo $EOR_REPOSITORY_PWD | sed -e 's/\\/\\\\/g' -e 's/\./\\./g' -e 's/\//\\\//g' -e 's/\$/\\$/g' -e 's/\*/\\*/g' -e 's/\[/\\[/g' -e 's/\]/\\]/g' -e 's/\^/\\^/g')

CARTE_PWD=$(echo $CARTE_PWD | sed -e 's/\\/\\\\/g' -e 's/\./\\./g' -e 's/\//\\\//g' -e 's/\$/\\$/g' -e 's/\*/\\*/g' -e 's/\[/\\[/g' -e 's/\]/\\]/g' -e 's/\^/\\^/g')

DASHBUILDER_DATABASE_IP=$(echo $DASHBUILDER_DATABASE_IP | sed -e 's/\\/\\\\/g' -e 's/\./\\./g' -e 's/\//\\\//g' -e 's/\$/\\$/g' -e 's/\*/\\*/g' -e 's/\[/\\[/g' -e 's/\]/\\]/g' -e 's/\^/\\^/g')
DASHBUILDER_DATABASE_USER=$(echo $DASHBUILDER_DATABASE_USER | sed -e 's/\\/\\\\/g' -e 's/\./\\./g' -e 's/\//\\\//g' -e 's/\$/\\$/g' -e 's/\*/\\*/g' -e 's/\[/\\[/g' -e 's/\]/\\]/g' -e 's/\^/\\^/g')
DASHBUILDER_DATABASE_PWD=$(echo $DASHBUILDER_DATABASE_PWD | sed -e 's/\\/\\\\/g' -e 's/\./\\./g' -e 's/\//\\\//g' -e 's/\$/\\$/g' -e 's/\*/\\*/g' -e 's/\[/\\[/g' -e 's/\]/\\]/g' -e 's/\^/\\^/g')
