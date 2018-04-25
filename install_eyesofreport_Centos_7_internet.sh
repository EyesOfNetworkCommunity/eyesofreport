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

chmod -R +x $BASEDIR/

if [ ! -f "$BASEDIR/EXTERNAL_SOFTS/wildfly-9.0.1.Final.zip" ]; then
	echo "File EXTERNAL_SOFTS/wildfly-9.0.1.Final.zip not found. Please follow EXTERNAL_SOFTS/README.txt before Eyes Of Report Installation";
	echo -e "Eyes Of Report installation \e[31m[CANCELLED] \e[39m";
	exit 1;
fi

if [ ! -f "$BASEDIR/EXTERNAL_SOFTS/jdk-7u79-linux-x64.tar.gz" ]; then
	echo "File EXTERNAL_SOFTS/jdk-7u79-linux-x64.tar.gz not found. Please follow EXTERNAL_SOFTS/README.txt before Eyes Of Report Installation";
	echo -e "Eyes Of Report installation \e[31m[CANCELLED] \e[39m";
	exit 1;
fi

if [ ! -f "$BASEDIR/EXTERNAL_SOFTS/data-integration.zip" ]; then
	echo "File EXTERNAL_SOFTS/data-integration.zip not found. Please follow EXTERNAL_SOFTS/README.txt before Eyes Of Report Installation";
	echo -e "Eyes Of Report installation \e[31m[CANCELLED] \e[39m";
	exit 1;
fi

echo "Merge external softwares in Eyes Of Report installation..."
cp $BASEDIR/EXTERNAL_SOFTS/wildfly-9.0.1.Final.zip $BASEDIR/REPORTING
cp $BASEDIR/EXTERNAL_SOFTS/jdk-7u79-linux-x64.tar.gz $BASEDIR/CORE
cp $BASEDIR/EXTERNAL_SOFTS/data-integration.zip $BASEDIR/ETL

if [ -d /srv/eyesofreport ]; then
	while true; do
		read -p " Previous EyesOfReport installation exists on this machine. Do you want to remove it (y/n)? " yn
		case $yn in
			[Yy]*) rm -rf /srv/eyesofreport;break;;
			[Nn]*) echo -e "Eyes Of Report installation \e[31m[CANCELLED] \e[39m";exit 1;;
			*) echo "Please type y or n";;
		esac
	done
fi

mkdir -p /var/lib/docker
mkdir /srv/eyesofreport

echo  "Eyes Of Report packages installation..."
yum install -y perl net-tools nano docker unzip zip rsync bind-utils patch dos2unix firewalld wget net-snmp net-snmp-utils mariadb-server 2&> $BASEDIR/log_packet_install.log
yum install -y httpd-tools httpd libxslt php-common php-mysqlnd php php-xml php-xmlrpc php-ldap 2&>> $BASEDIR/log_packet_install.log
yum localinstall -y $BASEDIR/CORE/rpm/mod_auth_eon-5.0-1.eon.x86_64.rpm

TZONE=`ls -l /etc/localtime |awk -F "zoneinfo/" '{print $2}'`
sed -i "s,^;date.timezone.*,date.timezone = \"${TZONE}\",g" /etc/php.ini
echo -e "\n# eorweb\napache ALL=NOPASSWD:/bin/systemctl * docker,/bin/systemctl * pentaho,/bin/systemctl * ,/bin/systemctl * snmpd,/bin/systemctl * wildfly" >> /etc/sudoers

mysql_port=3306
snmpd_port=161
firewall-cmd --zone=public --add-port=$mysql_port/tcp --permanent > /dev/null
echo -e "Opening $mysql_port port on firewalld for mysql	 \e[92m[OK] \e[39m"
firewall-cmd --zone=public --add-port=$snmpd_port/tcp --permanent > /dev/null
firewall-cmd --zone=public --add-port=$snmpd_port/udp --permanent > /dev/null
echo -e "Opening $snmpd_port port on firewalld for snmp	 \e[92m[OK] \e[39m"
firewall-cmd --reload > /dev/null
echo -e "Firewalld reloaded \e[92m[OK] \e[39m"

yes | cp $BASEDIR/CORE/config/snmpd.conf /etc/snmp/
systemctl enable snmpd
systemctl enable mariadb

mkdir -p /run/httpd
echo -e "Eyes Of Report packages installation \e[92m[OK] \e[39m"

######### VERSION ##########
echo -e "EyesOfReport Linux Release 2.1 (\033[33;5;22mIn memoriam: Jean Louis\033[0;0;0m,\033[32;5;22m ICJS Anne Sophie\033[0;0;0m)"  > /etc/redhat-release

cat /etc/redhat-release > /etc/issue
echo 'Kernel \r on an \m' >> /etc/issue
echo '' >> /etc/issue
echo 'EyesOfReport access  : http://'`ip add show |grep "inet " |grep -v "127.0.0.1" |head -n 1 |awk '{print $2}' |awk -F "/" '{print $1}'`'/' >> /etc/issue
echo 'EyesOfReport website : https://github.com/EyesOfNetworkCommunity/eyesofreport' >> /etc/issue
echo '' >> /etc/issue
######### VERSION ##########

cd /srv/eyesofreport/

mkdir -p ./configuration
cp $BASEDIR/CONF/eyesofreport.sh ./configuration

echo "Extracting Java archive..."
tar xvzf $BASEDIR/CORE/jdk-7u79-linux-x64.tar.gz > /dev/null
ln -s /srv/eyesofreport/jdk1.7.0_79 /srv/eyesofreport/java
echo "export JAVA_HOME=/srv/eyesofreport/java" > /etc/profile.d/java.sh
echo "export PATH=\$PATH:/srv/eyesofreport/java/bin" >> /etc/profile.d/java.sh
chmod +x /etc/profile.d/java.sh

export JAVA_HOME=/srv/eyesofreport/java
export PATH=$PATH:/srv/eyesofreport/java/bin
echo -e "Java 7 installation \e[92m[OK] \e[39m"

########################################### MYSQL INITIALSATION ######################################

PURGE_EXPECT_WHEN_DONE=0
CURRENT_MYSQL_PASSWORD=''
NEW_MYSQL_PASSWORD='root66'

service mariadb start

if [ $(mysql -e "SELECT 1 as test" | grep -c 1 2> /dev/null ) -eq 1 ]; then
	CURRENT_MYSQL_PASSWORD=''
	mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -uroot mysql
else
	echo "Don't take into account previous mysql error, it's a test"
	if [ $(MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot mysql -e "SELECT 1 as test" | grep -c 1) -eq 1 ]; then
		CURRENT_MYSQL_PASSWORD=$NEW_MYSQL_PASSWORD
		mysql_tzinfo_to_sql /usr/share/zoneinfo | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot mysql > /dev/null
	else
		echo "You currently have mysql installation with root password. Please launch mysql_secure_installation and replace current root password by \"root,66\" only for the eyes of report installation duration. You could change root password after Eyes Of Report installation"
		exit 1
	fi
fi

cat $BASEDIR/CORE/databases/mysqlconf.txt > /etc/my.cnf
service mariadb restart

#
# Check if expect package installed
#
if [ $(rpm -qa | grep -c expect) -eq 0  ]; then
    echo "Can't find expect. Trying install it..."
    yum install -y expect >> /dev/null
fi

SECURE_MYSQL=$(expect -c "
set timeout 3
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"$CURRENT_MYSQL_PASSWORD\r\"
expect \"Set root password?\"
send \"Y\r\"
expect \"New password:\"
send \"$NEW_MYSQL_PASSWORD\r\"
expect \"Re-enter new password:\"
send \"$NEW_MYSQL_PASSWORD\r\"
expect \"Remove anonymous users?\"
send \"Y\r\"
expect \"Disallow root login remotely?\"
send \"n\r\"
expect \"Remove test database and access to it?\"
send \"n\r\"
expect \"Reload privilege tables now?\"
send \"Y\r\"
expect eof
")

echo -e "Mysql configuration \e[92m[OK] \e[39m"

########################## INSTALL INITIAL DATABASES #########################

#Create databases
NEW_MYSQL_PASSWORD=root66

if [ $(MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot -e 'SHOW DATABASES' | grep -c 'global_nagiosbp') -eq 0 ]; then
	echo "CREATE DATABASE global_nagiosbp;" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot
fi

if [ $(MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot -e 'SHOW DATABASES' | grep -c 'thruk') -eq 0 ]; then
	echo "CREATE DATABASE thruk;" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot
fi

if [ $(MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot -e 'SHOW DATABASES' | grep -c 'eor_ods') -eq 0 ]; then
	echo "CREATE DATABASE eor_ods;" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot
fi

if [ $(MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot -e 'SHOW DATABASES' | grep -c 'eor_dwh') -eq 0 ]; then
	echo "CREATE DATABASE eor_dwh;" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot
fi

if [ $(MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot -e 'SHOW DATABASES' | grep -c 'eyesofreport') -eq 0 ]; then
	echo "CREATE DATABASE eyesofreport;" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot
fi

if [ $(MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot -e 'SHOW DATABASES' | grep -c 'bp_group_lilac') -eq 0 ]; then
	echo "CREATE DATABASE bp_group_lilac;" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot
fi

#Create eyesofreport user
if [ $(MYSQL_PWD=root66 mysql -e "select user from mysql.user where user = 'eyesofreport' and host = 'localhost'" | grep -c eyesofreport) -eq 0 ]; then
	echo "CREATE USER 'eyesofreport'@'localhost' IDENTIFIED BY 'SaintThomas,2014'" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot
fi

#Grant privileges to eyesofreport user
echo "GRANT ALL PRIVILEGES on global_nagiosbp.* to 'eyesofreport'@'localhost';" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot
echo "GRANT ALL PRIVILEGES on thruk.* to 'eyesofreport'@'localhost';" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot
echo "GRANT ALL PRIVILEGES on eor_ods.* to 'eyesofreport'@'localhost';" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot
echo "GRANT ALL PRIVILEGES on eor_dwh.* to 'eyesofreport'@'localhost';" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot
echo "GRANT ALL PRIVILEGES on eyesofreport.* to 'eyesofreport'@'localhost';" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot
echo "GRANT ALL PRIVILEGES on bp_group_lilac.* to 'eyesofreport'@'localhost';" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot

echo "FLUSH PRIVILEGES;" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot
#Import database script
MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot global_nagiosbp < $BASEDIR/CORE/databases/global_nagiosbp.sql
MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot eor_ods < $BASEDIR/CORE/databases/eor_ods.sql
MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot eor_dwh < $BASEDIR/CORE/databases/eor_dwh.sql
MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot eyesofreport < $BASEDIR/CORE/databases/eyesofreport.sql
MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot bp_group_lilac < $BASEDIR/CORE/databases/bp_group_lilac.sql

#Fill time database
cd $BASEDIR/CORE/databases/
unzip ./d_time_dimension.zip > /dev/null
MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot eor_dwh < $BASEDIR/CORE/databases/d_time_dimension.sql
echo "Time dimension index creation : this step should take a few time"
echo "CREATE INDEX idx_d_time_dimension_hour on d_time_dimension(epoch_hour) using btree" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot eor_dwh
echo "CREATE INDEX idx_d_time_dimension_day on d_time_dimension(epoch_day) using btree" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot eor_dwh
echo "CREATE INDEX idx_d_time_dimension_month on d_time_dimension(epoch_month) using btree" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot eor_dwh
echo "CREATE INDEX idx_d_time_dimension_month_hour on d_time_dimension(epoch_month_hour) using btree" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot eor_dwh
echo "CREATE INDEX td_dbdate_idx on d_time_dimension(db_datetime) using btree" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot eor_dwh
echo "CREATE INDEX idx_d_time_dimension_year on d_time_dimension(year) using btree" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot eor_dwh
echo "CREATE INDEX idx_d_time_dimension_month_num on d_time_dimension(month) using btree" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot eor_dwh

echo -e "Technical databases installed \e[92m[OK] \e[39m"

########################################### Initialise basic containers #####################################
systemctl enable docker > /dev/null
service docker start > /dev/null
service docker restart > /dev/null
cd $BASEDIR/CORE/dockers
echo -e "Import container centos_systemd..."
unzip ./centos_1503.zip
docker load < $BASEDIR/CORE/dockers/centos_1503.tar
docker load < $BASEDIR/CORE/dockers/busybox.tar

OUT=$?
if [ ! $OUT -eq 0 ]; then
	echo -e "Import container centos_systemd 	\e[31m[FAILED] \e[39m"
	exit 1
else
	echo -e "Import container centos_systemd	\e[92m[OK] \e[39m"

fi

sed -ie 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
sed -ie 's/SELINUX=permissive/SELINUX=disabled/g' /etc/selinux/config

echo -e "Core installation \e[92m[FINISHED] \e[39m"

$BASEDIR/ETL/install_pentaho.sh

OUT=$?
if [ ! $OUT -eq 0 ]; then
	echo -e " 	\e[31m[FAILED] \e[39m"
	exit 1
else
	echo -e "ETL part installation	\e[92m[SUCCESS] \e[39m"

fi

$BASEDIR/REPORTING/install_reporting.sh

OUT=$?
if [ ! $OUT -eq 0 ]; then
	echo -e " 	\e[31m[FAILED] \e[39m"
	exit 1
else
	echo -e "Reporting part installation	\e[92m[SUCCESS] \e[39m"
fi

$BASEDIR/WEB/install_web.sh

OUT=$?
if [ ! $OUT -eq 0 ]; then
	echo -e " 	\e[31m[FAILED] \e[39m"
	exit 1
else
	echo -e "EOR Web part installation	\e[92m[SUCCESS] \e[39m"
	echo -e "Eyes Of Report installation	\e[92m[FINISHED] \e[39m"
fi

#Copy source creation folder in /srv/eyesofreport/
mkdir /srv/eyesofreport/external_connection
cp -r $BASEDIR/SOURCES/* /srv/eyesofreport/external_connection

while true; do
		read -p " To finish the installation you need to reboot the machine. Do you want to reboot now? " yn
		case $yn in
			[Yy]*) reboot;break;;
			[Nn]*) exit 0;;
			*) echo "Please type y or n";;
		esac
done


