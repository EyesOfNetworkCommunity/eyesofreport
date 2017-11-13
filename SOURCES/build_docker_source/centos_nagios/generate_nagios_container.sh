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

if [ -z "$1" ]
  then
    echo "Usage : generate_nagios_container.sh source_trigram site_trigram thuk_livestatus_backend_id"
	echo "	source_trigram : source indentification trigram (e.g. eon for eyesofnetwork)"
	echo "	site_trigram : site indentification trigram (e.g. ma1 for marignane)"
	echo "	thuk_livestatus_backend_id : five alphanumeric characters (e.g. 1234b)"
	exit
fi

if [ -z "$2" ]
  then
    echo "Usage : generate_nagios_container.sh source_trigram site_trigram thuk_livestatus_backend_id"
	echo "	source_trigram : source indentification trigram (e.g. eon for eyesofnetwork)"
	echo "	site_trigram : site indentification trigram (e.g. ma1 for marignane)"
	echo "	thuk_livestatus_backend_id : five alphanumeric characters (e.g. 1234b)"
	exit
fi

if [ -z "$3" ]
  then
    echo "Usage : generate_nagios_container.sh source_trigram site_trigram thuk_livestatus_backend_id"
	echo "	source_trigram : source indentification trigram (e.g. eon for eyesofnetwork)"
	echo "	site_trigram : site indentification trigram (e.g. ma1 for marignane)"
	echo "	thuk_livestatus_backend_id : five alphanumeric characters (e.g. 1234b)"
	exit
fi

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source_trigram=$1
site_trigram=$2
livestatus_prefix=$3
source_site=${site_trigram}_${source_trigram}
MYSQL_ROOT=root66

source /srv/eyesofreport/configuration/eyesofreport.sh 
#source $BASEDIR/../../../CONF/convert_env_variables.sh
MYSQL_EOR=$EOR_DATABASE_PWD

source_nagios_path=/srv/eyesofreport/docker_script/centos_nagios_${site_trigram}_${source_trigram}
installation_path=$BASEDIR
log_file=$source_nagios_path/centos_nagios/log_centos_nagios_${site_trigram}_${source_trigram}

mkdir -p $source_nagios_path/centos_nagios

cd $installation_path/Install_Files
tar cvf ./Install_Files.tar ./* >> $log_file
mv ./Install_Files.tar $installation_path

cp $installation_path/Dockerfile $source_nagios_path/centos_nagios >> $log_file
cp $installation_path/generate_nagios_container.sh $source_nagios_path/centos_nagios >> $log_file
cp $installation_path/start.sh $source_nagios_path/centos_nagios/start_nagios_${site_trigram}_${source_trigram}.sh >> $log_file
cp $installation_path/Install_Files.tar $source_nagios_path/centos_nagios >> $log_file
cp $installation_path/generic_nagios_docker.service $source_nagios_path/centos_nagios/${site_trigram}_${source_trigram}_nagios_container.service >> $log_file
cp -r $installation_path/Host_Files/* /srv/eyesofreport

rm -f $installation_path/Install_Files.tar

cd /srv/eyesofreport
#tar xvf ./Host_Files.tar
chmod -R +x /srv/eyesofreport/scripts
#rm ./Host_Files.tar
echo -e "Environment centos_nagios_${source_trigram} \e[92m[OK] \e[39m"


#test if thuk database exists
thruk_database=$(MYSQL_PWD="$MYSQL_EOR" mysql -ueyesofreport -e 'show databases' | grep thruk)
if [ "$thruk_database" == "thruk" ]; then
	echo -e "database thruk already exists	\e[92m[OK] \e[39m"
else 
	MYSQL_PWD="$MYSQL_ROOT" mysql -uroot -e "create database thruk;"
	MYSQL_PWD="$MYSQL_ROOT" mysql -uroot -e "grant all privileges on thruk.* to 'eyesofreport'@'%'; "
	MYSQL_PWD="$MYSQL_ROOT" mysql -uroot -e "grant all privileges on thruk.* to 'eyesofreport'@'localhost'; "
	echo -e "database thruk created	\e[92m[OK] \e[39m"
fi

#test if nagios_bp database exists
nagiosbp_database=${site_trigram}_${source_trigram}_nagiosbp
test_db=$(MYSQL_PWD="$MYSQL_EOR" mysql -ueyesofreport -e 'show databases' | grep $nagiosbp_database$)
drop_database=y
if [ "$test_db" == "$nagiosbp_database" ]; then
        while true; do
		read -p "Database $nagiosbp_database already exists. Do you want to drop it ? (y/n)" yn
		case $yn in
			[Nn]* ) drop_database=n;echo -e "Existing database $nagiosbp_database conserved	\e[92m[OK] \e[39m";break;;
			[Yy]* ) MYSQL_PWD="$MYSQL_EOR" mysql -ueyesofreport -e "drop database $nagiosbp_database;";break;;
			* ) echo "Please answer y or n.";;
		esac
	done
fi
if [ "$drop_database" == "y" ]; then 
	MYSQL_PWD="$MYSQL_ROOT" mysql -uroot -e "create database $nagiosbp_database;"
	MYSQL_PWD="$MYSQL_ROOT" mysql -uroot $nagiosbp_database < $installation_path/generic_nagiosbp.sql
	MYSQL_PWD="$MYSQL_ROOT" mysql -uroot -e "grant all privileges on $nagiosbp_database.* to 'eyesofreport'@'%'; "
	MYSQL_PWD="$MYSQL_ROOT" mysql -uroot -e "grant all privileges on $nagiosbp_database.* to 'eyesofreport'@'localhost'; "
	echo -e "database $nagiosbp_database created	\e[92m[OK] \e[39m"
fi


#test if lilac database exists
lilac_database=${site_trigram}_${source_trigram}_lilac
test_db=$(MYSQL_PWD="$MYSQL_EOR" mysql -ueyesofreport -e 'show databases' | grep $lilac_database$)
drop_database=y
if [ "$test_db" == "$lilac_database" ]; then
        while true; do
		read -p "Database $lilac_database already exists. Do you want to drop it ? (y/n)" yn
		case $yn in
			[Nn]* ) drop_database=n;echo -e "Existing database $lilac_database conserved	\e[92m[OK] \e[39m";break;;
			[Yy]* ) MYSQL_PWD="$MYSQL_EOR" mysql -ueyesofreport -e "drop database $lilac_database;";break;;
			* ) echo "Please answer y or n.";;
		esac
	done
fi
if [ "$drop_database" == "y" ]; then 
	MYSQL_PWD="$MYSQL_ROOT" mysql -uroot -e "create database $lilac_database;"
	MYSQL_PWD="$MYSQL_ROOT" mysql -uroot $lilac_database < $installation_path/generic_lilac.sql
	MYSQL_PWD="$MYSQL_ROOT" mysql -uroot -e "grant all privileges on $lilac_database.* to 'eyesofreport'@'%'; "
	MYSQL_PWD="$MYSQL_ROOT" mysql -uroot -e "grant all privileges on $lilac_database.* to 'eyesofreport'@'localhost'; "
	echo -e "database $lilac_database created	\e[92m[OK] \e[39m"
fi

#test if ged database exists
ged_database=${site_trigram}_${source_trigram}_ged
test_db=$(MYSQL_PWD="$MYSQL_EOR" mysql -ueyesofreport -e 'show databases' | grep $ged_database$)
drop_database=y
if [ "$test_db" == "$ged_database" ]; then
        while true; do
		read -p "Database $ged_database already exists. Do you want to drop it ? (y/n)" yn
		case $yn in
			[Nn]* ) drop_database=n;echo -e "Existing database $ged_database conserved	\e[92m[OK] \e[39m";break;;
			[Yy]* ) MYSQL_PWD="$MYSQL_EOR" mysql -ueyesofreport -e "drop database $ged_database;";break;;
			* ) echo "Please answer y or n.";;
		esac
	done
fi
if [ "$drop_database" == "y" ]; then 
	MYSQL_PWD="$MYSQL_ROOT" mysql -uroot -e "create database $ged_database;"
	MYSQL_PWD="$MYSQL_ROOT" mysql -uroot $ged_database < $installation_path/generic_ged.sql
	MYSQL_PWD="$MYSQL_ROOT" mysql -uroot -e "grant all privileges on $ged_database.* to 'eyesofreport'@'%'; "
	MYSQL_PWD="$MYSQL_ROOT" mysql -uroot -e "grant all privileges on $ged_database.* to 'eyesofreport'@'localhost'; "
	echo -e "database $ged_database created	\e[92m[OK] \e[39m"
fi

cd $source_nagios_path/centos_nagios >> $log_file

container_name=centos_nagios_${site_trigram}_${source_trigram} >> $log_file

#replace into Dockerfile the thruk livestatus backend id
sed -i "s/livestatus_code/$livestatus_prefix/g" $source_nagios_path/centos_nagios/Dockerfile
sed -i "s/source_site/$source_site/g" $source_nagios_path/centos_nagios/Dockerfile

site_source=${site_trigram}_${source_trigram}

sed -i "s/\$1/$container_name/g" ./start_nagios_${site_trigram}_${source_trigram}.sh >> $log_file
sed -i "s/\$2/$site_source/g" ./start_nagios_${site_trigram}_${source_trigram}.sh >> $log_file

#customize nagios.service file
nagios_container_service=${site_source}_nagios_container.service
sed -i "s/container_description/${site_source} Nagios Container/g" ./$nagios_container_service >> $log_file
sed -i "s/container_folder/centos_nagios_${site_source}/g" ./$nagios_container_service >> $log_file
sed -i "s/start_file/start_nagios_${site_source}/g" ./$nagios_container_service >> $log_file
sed -i "s/container_name/centos_nagios_${site_source}/g" ./$nagios_container_service >> $log_file
sed -i "s/\$1/$container_name/g" ./$nagios_container_service >> $log_file
sed -i "s/\$2/$site_source/g" ./$nagios_container_service >> $log_file
sed -i "s/--volumes-from ssh_data/--volumes-from data_container_${site_source}/g" ./$nagios_container_service >> $log_file

cp ./$nagios_container_service /etc/systemd/system

systemctl daemon-reload
systemctl enable ${site_source}_nagios_container.service

echo -e "Show container creation log : tail -f /srv/eyesofreport/docker_script/centos_nagios_${site_trigram}_${source_trigram}/centos_nagios/log_centos_nagios_${site_trigram}_${source_trigram}"

docker build -t "$container_name" . >> $log_file
OUT=$?
if [ $OUT -eq 0 ];then
   echo -e "Nagios container $container_name creation 	\e[92m[OK] \e[39m"
   service ${site_source}_nagios_container start
   docker exec -d $container_name /srv/eyesofreport/scripts/insert_nagios_to_thrukDB.sh
else
   echo -e "Nagios container $container_name creation 	\e[31m[FAILED] \e[39m"
   echo "See logs $source_nagios_path/centos_nagios/log_centos_nagios_${source_trigram} "
   exit 1
fi

pentaho_continue=1
		while [ -n "$(cat /etc/cron.d/eyesofreport | grep -n -m 1 "docker exec -d $container_name /srv/eyesofreport/scripts/insert_nagios_to_thrukDB.sh" | awk -F ":" '{print $1}')" ]; 
		do
			myLine=$(cat /etc/cron.d/eyesofreport | grep -n -m 1 "docker exec -d $container_name /srv/eyesofreport/scripts/insert_nagios_to_thrukDB.sh" | awk -F ":" '{print $1}')
			while true; do
				read -p "Nagios log insert job for $site_source is already scheduled in /etc/cron.d/eyesofreport on eyes of report server. Do you want to remove it ? (y/n)" yn
				case $yn in
					[Yy]* ) sed -i -e "$myLine"'d' /etc/cron.d/eyesofreport;break;;
					[Nn]* ) echo -e "Nagios log insert job for $site_source  :	\e[33m[CANCELED] \e[39m";pentaho_continue=0;break;;
					* ) echo "Please answer y or n.";;
				esac
			done
		
			if [ $pentaho_continue -eq 0 ]; then
				break;
			fi

		done

		if [ $pentaho_continue -eq 1 ]; then
			echo "30 2 * * * root docker exec -d $container_name /srv/eyesofreport/scripts/insert_nagios_to_thrukDB.sh" >> /etc/cron.d/eyesofreport
			chmod +x /srv/eyesofreport/scripts/insert_nagios_to_thrukDB.sh
			echo -e "Nagios log insert job for $site_source	 \e[92m[OK] \e[39m"
		fi

pentaho_continue=1
		while [ -n "$(cat /etc/cron.d/eyesofreport | grep -n -m 1 "docker exec -d $container_name /srv/eyesofreport/scripts/insert_eon_DB.sh $site_source" | awk -F ":" '{print $1}')" ]; 
		do
			myLine=$(cat /etc/cron.d/eyesofreport | grep -n -m 1 "docker exec -d $container_name /srv/eyesofreport/scripts/insert_eon_DB.sh $site_source" | awk -F ":" '{print $1}')
			while true; do
				read -p "Livestatus sql dump insert job for $site_source is already scheduled in /etc/cron.d/eyesofreport on eyes of report server. Do you want to remove it ? (y/n)" yn
				case $yn in
					[Yy]* ) sed -i -e "$myLine"'d' /etc/cron.d/eyesofreport;break;;
					[Nn]* ) echo -e "Livestatus sql dump insert job for $site_source  :	\e[33m[CANCELED] \e[39m";pentaho_continue=0;break;;
					* ) echo "Please answer y or n.";;
				esac
			done
		
			if [ $pentaho_continue -eq 0 ]; then
				break;
			fi

		done

		if [ $pentaho_continue -eq 1 ]; then
			echo "40 2 * * * root docker exec -d $container_name /srv/eyesofreport/scripts/insert_eon_DB.sh $site_source" >> /etc/cron.d/eyesofreport
			chmod +x /srv/eyesofreport/scripts/insert_eon_DB.sh
			echo -e "Livestatus sql dump insert job for $site_source	 \e[92m[OK] \e[39m"
		fi

exit 0
