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


#THIS FILE IS ONLY HERE TO GIVE YOU INITIAL CONFIGURATION VARIABLE USED DURING EyesOfReport Installation
#You have specific comment to indicate where each variable is used

#DATABASE eyesofreport
#Location : /srv/eyesofreport/etl/data-integration/simple-jndi/jdbc.properties 
EOR_TECHNIC_DATABASE_IP=localhost
EOR_TECHNIC_DATABASE_USER=eyesofreport
EOR_TECHNIC_DATABASE_PWD='SaintThomas,2014'

#DATABASE global_nagiosbp
#Location : /srv/eyesofreport/etl/data-integration/simple-jndi/jdbc.properties
EOR_WEB_DATABASE_IP=localhost
EOR_WEB_DATABASE_USER=eyesofreport
EOR_WEB_DATABASE_PWD='SaintThomas,2014'

#DATABASES eor_ods, eor_dwh, nagiosbp, lilac, thruk, ged
#Location : /srv/eyesofreport/etl/data-integration/simple-jndi/jdbc.properties
#Location : /srv/eyesofreport/appserver/wildfly/standalone/configuration/standalone.xml for DWH and eyesofreport datasource
EOR_DATABASE_IP=localhost
EOR_DATABASE_USER=eyesofreport
EOR_DATABASE_PWD='SaintThomas,2014'

#DATABASE eyesofreport
#Location : /srv/eyesofreport/etl/data-integration/simple-jndi/jdbc.properties
EOR_REPOSITORY_IP=localhost
EOR_REPOSITORY_USER=eyesofreport
EOR_REPOSITORY_PWD='SaintThomas,2014'

#CARTE_USER value is displayed for your information. Don't change this value, this will not have impact.
#CARTE_USER=cluster
#PASSWORD OF CARTE WEB SERVICE http://eyesofreport_machine:8181
CARTE_PWD='root66'

#dashbuilder database
#Location : /srv/eyesofreport/appserver/wildfly/standalone/configuration/standalone.xml for ExampleDS datasource
DASHBUILDER_DATABASE_IP=localhost
DASHBUILDER_DATABASE_USER=dashbuilder
DASHBUILDER_DATABASE_PWD='dashbuilder'

#eor web database
#Location : /srv/eyesofnetwork/include/configuration.php
EOR_WEB_DATABASE_IP=localhost
EOR_WEB_DATABASE_USER=eyesofreport
EOR_WEB_DATABASE_PWD='SaintThomas,2014'

#eor web version
eor_web_version=1.0
