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

echo "Eyes of report Report brick creation"

wildlfy_port=8080
wildlfy_admin_port=9990

firewall-cmd --zone=public --add-port=$wildlfy_port/tcp --permanent > /dev/null
echo -e "Opening $wildlfy_port port on firewalld for wildfly application access	 \e[92m[OK] \e[39m"
firewall-cmd --zone=public --add-port=$wildlfy_admin_port/tcp --permanent > /dev/null
echo -e "Opening $wildlfy_admin_port port on firewalld for wildfly console access	 \e[92m[OK] \e[39m"
firewall-cmd --reload > /dev/null
echo -e "Reload firewalld \e[92m[OK] \e[39m"

installation_path=$BASEDIR
reporting_path=/srv/eyesofreport/report
wildfly_path=/srv/eyesofreport/appserver
log_file=$reporting_path/installation_log
MYSQL_ROOT=root66

source $BASEDIR/../CONF/eyesofreport.sh
source $BASEDIR/../CONF/convert_env_variables.sh

MYSQL_EOR='$EOR_DATABASE_PWD'

if [ ! -d "/var/log/wildfly" ]; then
	mkdir -p /var/log/wildfly
fi

if [ -d "$reporting_path" ]; then
	while true; do
		read -p "Reporting environment already exists (/srv/eyesofreport/report). Remove it ? (y/n)" yn
		case $yn in
			[Yy]* ) rm -rf $reporting_path;mkdir -p $reporting_path;break;;
			[Nn]* ) exit;;
			* ) echo "Please answer y or n.";;
		esac
	done
else mkdir -p $reporting_path
fi

if [ -d "$wildfly_path" ]; then
	while true; do
		read -p "Wildfly environment already exists (/srv/eyesofreport/appserver). Remove it ? (y/n)" yn
		case $yn in
			[Yy]* ) rm -rf $wildfly_path;mkdir -p $wildfly_path;break;;
			[Nn]* ) exit;;
			* ) echo "Please answer y or n.";;
		esac
	done
else mkdir -p $wildfly_path
fi

cd $installation_path


cp $installation_path/wildfly-9.0.1.Final.zip $wildfly_path >> $log_file
cp -r $installation_path/wildfly-eor/ $wildfly_path >> $log_file

cd $wildfly_path
echo "Extracting application server wildfly archive"
unzip $wildfly_path/wildfly-9.0.1.Final.zip > /dev/null
ln -s $wildfly_path/wildfly-9.0.1.Final $wildfly_path/wildfly

#MERGE initial wildfly folder with Eyes Of Report specific configuration and deployment files
cp $wildfly_path/wildfly-eor/bin/wildfly.service $wildfly_path/wildfly/bin/
mv $wildfly_path/wildfly-eor/com $wildfly_path/wildfly/modules/
yes | cp $wildfly_path/wildfly-eor/configuration/* $wildfly_path/wildfly/standalone/configuration/ > /dev/null
cp $wildfly_path/wildfly-eor/deployment/* $wildfly_path/wildfly/standalone/deployments/

source $BASEDIR/../CONF/eyesofreport.sh
source $BASEDIR/../CONF/convert_env_variables.sh
sed -i "s/EOR_DATABASE/$EOR_DATABASE_IP/g" $wildfly_path/wildfly-9.0.1.Final/standalone/configuration/standalone.xml
sed -i "s/EOR_DB_USER/$EOR_DATABASE_USER/g" $wildfly_path/wildfly-9.0.1.Final/standalone/configuration/standalone.xml
sed -i "s/EOR_DB_PWD/$EOR_DATABASE_PWD/g" $wildfly_path/wildfly-9.0.1.Final/standalone/configuration/standalone.xml
sed -i "s/DASHBUILDER_DATABASE/$DASHBUILDER_DATABASE_IP/g" $wildfly_path/wildfly-9.0.1.Final/standalone/configuration/standalone.xml
sed -i "s/DASHBUILDER_DB_USER/$DASHBUILDER_DATABASE_USER/g" $wildfly_path/wildfly-9.0.1.Final/standalone/configuration/standalone.xml
sed -i "s/DASHBUILDER_DB_PWD/$DASHBUILDER_DATABASE_PWD/g" $wildfly_path/wildfly-9.0.1.Final/standalone/configuration/standalone.xml
source $BASEDIR/../CONF/eyesofreport.sh

yes | rm $wildfly_path/wildfly-9.0.1.Final.zip

cd $reporting_path
cp $installation_path/report/* ./

#clean installation folder
#rm $installation_path/wildfly-9.0.1.Final.zip
#rm $installation_path/convertDatabaseEnvVariables.sh
#rm $installation_path/report.tar

groupadd -r eyesofnetwork
chmod 775 /srv/eyesofreport/report
chown root:eyesofnetwork /srv/eyesofreport/report

echo -e "Reporting Environment \e[92m[OK] \e[39m"

#test if dashbuilder database exists
test_db=$(MYSQL_PWD="$MYSQL_ROOT" mysql -uroot -e 'show databases;' | grep dashbuilder)
drop_database=y
if [ "$test_db" == "dashbuilder" ]; then
        while true; do
		read -p "Database dashbuilder already exists. Do you want to drop it ? (y/n)" yn
		case $yn in
			[Nn]* ) drop_database=n;echo -e "Existing database dashbuilder conserved	\e[92m[OK] \e[39m";break;;
			[Yy]* ) MYSQL_PWD="$MYSQL_ROOT" mysql -uroot -e "drop database dashbuilder;";break;;
			* ) echo "Please answer y or n.";;
		esac
	done
fi
if [ "$drop_database" == "y" ]; then 
#generate database user + mdp

	echo "CREATE DATABASE dashbuilder" | MYSQL_PWD="$MYSQL_ROOT" mysql -uroot -h$DASHBUILDER_DATABASE_IP
	MYSQL_PWD="$MYSQL_ROOT" mysql -uroot dashbuilder -h$DASHBUILDER_DATABASE_IP < $installation_path/dashbuilder.sql
	
#	if [ $(MYSQL_PWD=$MYSQL_ROOT mysql -e "select user from mysql.user where user = '$DASHBUILDER_DATABASE_USER' and host = '%'" | grep -c $DASHBUILDER_DATABASE_USER) -eq 0 ]; then
#		echo "CREATE USER '$DASHBUILDER_DATABASE_USER'@'%' identified by '$DASHBUILDER_DATABASE_PWD'" | MYSQL_PWD="$MYSQL_ROOT" mysql -uroot	-h$DASHBUILDER_DATABASE_IP
#	fi
	
	if [ $(MYSQL_PWD=$MYSQL_ROOT mysql -e "select user from mysql.user where user = '$DASHBUILDER_DATABASE_USER' and host = 'localhost'" | grep -c $DASHBUILDER_DATABASE_USER) -eq 0 ]; then
		echo "CREATE USER '$DASHBUILDER_DATABASE_USER'@'localhost' identified by '$DASHBUILDER_DATABASE_PWD'" | MYSQL_PWD="$MYSQL_ROOT" mysql -uroot  -h$DASHBUILDER_DATABASE_IP
	fi

#	echo "GRANT ALL PRIVILEGES on dashbuilder.* to '$DASHBUILDER_DATABASE_USER'@'%'" | MYSQL_PWD="$MYSQL_ROOT" mysql -uroot -h$DASHBUILDER_DATABASE_IP
	echo "GRANT ALL PRIVILEGES on dashbuilder.* to '$DASHBUILDER_DATABASE_USER'@'localhost'" | MYSQL_PWD="$MYSQL_ROOT" mysql -uroot -h$DASHBUILDER_DATABASE_IP
	echo -e "database dashbuilder created	\e[92m[OK] \e[39m"
fi

chmod -R +x /srv/eyesofreport/appserver/
rm $installation_path/dashbuilder.sql

yes | cp $wildfly_path/wildfly/bin/wildfly.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable wildfly.service 
exit 0
