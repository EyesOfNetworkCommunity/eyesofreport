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

LILAC_REPODIR="/srv/eyesofreport/external_depot/Lilac/"
GED_REPODIR="/srv/eyesofreport/external_depot/Ged/"
NAGIOSBP_REPODIR="/srv/eyesofreport/external_depot/Nagios_BP/"
#SERVERNAME="fjord.eu.eurocopter.corp"
MYSQLUSER="eyesofreport"
PASSWDMsql="SaintThomas,2014"
Host="localhost"
SOURCE_NAME=$1

lilacdb="${SOURCE_NAME}_lilac"
geddb="${SOURCE_NAME}_ged"
nagiosbpdb="${SOURCE_NAME}_nagiosbp"

LastGedDump=$(ls -tr ${GED_REPODIR}*ged*.sql | tail -1)
LastLilacDump=$(ls -tr ${LILAC_REPODIR}*lilac*.sql | tail -1)
LastNagiosBPDump=$(ls -tr ${NAGIOSBP_REPODIR}*nagiosbp*.sql | tail -1)

MYSQL_PWD=${PASSWDMsql} mysql -u ${MYSQLUSER} -h ${Host} ${lilacdb} < $LastLilacDump
MYSQL_PWD=${PASSWDMsql} mysql -u ${MYSQLUSER} -h ${Host} ${geddb} < $LastGedDump
MYSQL_PWD=${PASSWDMsql} mysql -u ${MYSQLUSER} -h ${Host} ${nagiosbpdb} < $LastNagiosBPDump
