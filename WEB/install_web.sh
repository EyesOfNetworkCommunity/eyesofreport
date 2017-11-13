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

echo "Eyes of report Web brick creation"

web_port=80

firewall-cmd --zone=public --add-port=$web_port/tcp --permanent > /dev/null
echo -e "Opening $web_port port on firewalld for eyes of report web	 \e[92m[OK] \e[39m"
firewall-cmd --reload > /dev/null
echo -e "Reload firewalld \e[92m[OK] \e[39m"

installation_path=$BASEDIR
web_path=/srv/eyesofnetwork/
log_file=web_path/installation_log
MYSQL_ROOT=root66

source $BASEDIR/../CONF/eyesofreport.sh

eor_web_folder=eorweb-$eor_web_version

source $BASEDIR/../CONF/convert_env_variables.sh


#if [ ! -d /var/log/pentaho ]; then
#	mkdir -p /var/log/pentaho
#fi

if [ -d "$web_path" ]; then
	while true; do
		read -p "Eyesofreport web environment already exists (/srv/eyesofnetwork/eorweb). Remove it ? (y/n)" yn
		case $yn in
			[Yy]* ) rm -rf $web_path;mkdir -p $web_path;break;;
			[Nn]* ) exit;;
			* ) echo "Please answer y or n.";;
		esac
	done
else mkdir -p $web_path
fi

cd $installation_path
echo "Extract Eyesofreport web brick archive..."
#tar xvf $installation_path/Install_Files.tar > /dev/null

cp -r $installation_path/${eor_web_folder} $web_path

#tar xvf httpd.tar > /dev/null
yes | cp ./httpd/conf.d/* /etc/httpd/conf.d/ > /dev/null

cd $web_path

#tar xvf ${eor_web_folder}.tar > /dev/null
ln -s ${eor_web_folder} eorweb



sed -i "s/EOR_WEB_DATABASE_IP/$EOR_WEB_DATABASE_IP/g" ./eorweb/include/config.php 
sed -i "s/EOR_WEB_DATABASE_USER/$EOR_WEB_DATABASE_USER/g" ./eorweb/include/config.php 
sed -i "s/EOR_WEB_DATABASE_PWD/$EOR_WEB_DATABASE_PWD/g" ./eorweb/include/config.php 

cd $installation_path

#yes | rm -rf ./httpd
#yes | rm -rf ./httpd.tar


#test if eor_repository database exists
test_db=$(MYSQL_PWD="$EOR_WEB_DATABASE_PWD" mysql -ueyesofreport -e 'show databases' | grep eorweb)
drop_database=y
if [ "$test_db" == "eorweb" ]; then
        while true; do
		read -p "Database eorweb already exists. Do you want to drop it ? (y/n)" yn
		case $yn in
			[Nn]* ) drop_database=n;echo -e "Existing database eorweb conserved	\e[92m[OK] \e[39m";break;;
			[Yy]* ) MYSQL_PWD="$EOR_WEB_DATABASE_PWD" mysqldump -ueyesofreport eorweb > /tmp/eorweb.sql; echo "eorweb.sql dumped in /tmp"; MYSQL_PWD="$EOR_WEB_DATABASE_PWD" mysql -ueyesofreport -e "drop database eorweb;";break;;
			* ) echo "Please answer y or n.";;
		esac
	done
fi

if [ "$drop_database" == "y" ]; then 
	echo "CREATE DATABASE eorweb;" | MYSQL_PWD=$MYSQL_ROOT mysql -uroot  -h$EOR_WEB_DATABASE_IP 
	MYSQL_PWD=$MYSQL_ROOT mysql -uroot -h$EOR_WEB_DATABASE_IP eorweb < $installation_path/eorweb.sql
#	echo "GRANT ALL PRIVILEGES on eorweb.* to 'eyesofreport'@'%'" | MYSQL_PWD=$MYSQL_ROOT mysql -uroot  -h$EOR_WEB_DATABASE_IP 
	echo "GRANT ALL PRIVILEGES on eorweb.* to 'eyesofreport'@'localhost'" | MYSQL_PWD=$MYSQL_ROOT mysql -uroot  -h$EOR_WEB_DATABASE_IP
	echo -e "database eorweb created	\e[92m[OK] \e[39m"
fi
	
#rm $installation_path/eorweb.sql		

chmod -R +x $web_path

sed -ie 's/DocumentRoot "\/var\/www\/html"/DocumentRoot "\/srv\/eyesofnetwork\/eorweb"/g' /etc/httpd/conf/httpd.conf
sed -ie 's/Timeout 60/Timeout 5000/g' /etc/httpd/conf/httpd.conf
sed -ie 's/upload_max_filesize = 2M/upload_max_filesize = 50M/g' /etc/php.ini


#Eyes Of Network system group
cd /srv/eyesofnetwork
usermod -a -G eyesofnetwork apache
chown -R root:eyesofnetwork ./*
find . -type d -exec chmod o-rwx {} \;
find . -type d -exec chmod o+x {} \;
find . -type f -exec chmod o-rwx {} \;

yes | mv  $BASEDIR/httpd.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable httpd.service

exit 0

