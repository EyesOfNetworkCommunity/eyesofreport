#!/bin/bash

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
cp $BASEDIR/EXTERNAL_SOFTS/jdk-7u80-linux-x64.tar.gz $BASEDIR/CORE
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

#create eyessofreport yum repository
#if [ $(rpm -qa | grep -c deltarpm-3.6-3) -eq 0 ]; then
#	rpm -ivh $BASEDIR/CORE/createrepo/deltarpm-3.6-3.el7.x86_64.rpm
#fi
#
#if [ $(rpm -qa | grep -c libxml2-2.9.1-5.el7_1.2.x86_64) -eq 0 ]; then
#	rpm -ivh --replacefiles $BASEDIR/CORE/createrepo/libxml2-2.9.1-5.el7_1.2.x86_64.rpm 2> /dev/null
#fi
#
#if [ $(rpm -qa | grep -c libxml2-python-2.9.1-5) -eq 0 ]; then
#	rpm -ivh $BASEDIR/CORE/createrepo/libxml2-python-2.9.1-5.el7_1.2.x86_64.rpm
#fi
#
#if [ $(rpm -qa | grep -c python-deltarpm-3.6-3) -eq 0 ]; then
#	rpm -ivh $BASEDIR/CORE/createrepo/python-deltarpm-3.6-3.el7.x86_64.rpm
#fi
#
#if [ $(rpm -qa | grep -c createrepo-0.9.9-23) -eq 0 ]; then
#	rpm -ivh $BASEDIR/CORE/createrepo/createrepo-0.9.9-23.el7.noarch.rpm
#fi

mkdir -p /srv/eyesofreport/depot-1.0
#ln -s /srv/eyesofreport/depot-1.0 /srv/eyesofreport/depot

#cp $BASEDIR/CORE/rpm/* /srv/eyesofreport/depot

#echo "[localrepo]" > /etc/yum.repos.d/localrepo.repo
#echo "name=Eyesofreport repository" >> /etc/yum.repos.d/localrepo.repo
#echo "baseurl=file:///srv/eyesofreport/depot" >> /etc/yum.repos.d/localrepo.repo
#echo "gpgcheck=0" >> /etc/yum.repos.d/localrepo.repo
#echo "enabled=1" >> /etc/yum.repos.d/localrepo.repo

#createrepo -v /srv/eyesofreport/depot/ > /dev/null

#echo -e "Eyes Of Report repository creation \e[92m[OK] \e[39m"

#Delete all rpm http and php installed on the machine

#if [ $(rpm -qa | grep -c httpd-tools) -gt 0 ]; then
#	yum remove -y httpd 2&>1 /dev/null
#fi
#if [ $(rpm -qa | grep -c httpd) -gt 0 ]; then
#	yum remove -y httpd-tools 2&>1 /dev/null
#fi
#if [ $(rpm -qa | grep -c php-common) -gt 0 ]; then
#	yum remove -y php-common 2&>1 /dev/null
#fi
#if [ $(rpm -qa | grep -c php-pdo) -gt 0 ]; then
#	yum remove -y php-pdo 2&>1 /dev/null
#fi
#if [ $(rpm -qa | grep -c php-mysql) -gt 0 ]; then
#	yum remove -y php-mysql 2&>1 /dev/null
#fi
#if [ $(rpm -qa | grep -c php-cli) -gt 0 ]; then
#	yum remove -y php-cli 2&>1 /dev/null
#fi
#if [ $(rpm -qa | grep -c php-xmlrpc) -gt 0 ]; then
#	yum remove -y php-xmlrpc 2&>1 /dev/null
#fi
#if [ $(rpm -qa | grep -c php-xml) -gt 0 ]; then
#	yum remove -y php-xml 2&>1 /dev/null
#fi
#if [ $(rpm -qa | grep -c php-ldap) -gt 0 ]; then
#	yum remove -y php-ldap 2&>1 /dev/null
#fi
#if [ $(rpm -qa | grep -c php) -gt 0 ]; then
#	yum remove -y php 2&>1 /dev/null
#fi

mkdir -p /var/lib/docker

echo  "Eyes Of Report packages installation..."

yum install -y dos2unix net-snmp  mariadb-server httpd httpd-tools php-common php-mysqlnd php php-xml php-xmlrpc php-ldap expect
rpm -ivh $BASEDIR/CORE/rpm/mod_auth_eon-5.0-1.eon.x86_64.rpm

# yum install -y --disablerepo="*" --enablerepo="localrepo" perl net-tools nano docker unzip zip rsync bind-utils-9.9.4-18.el7_1.5.x86_64 patch dos2unix firewalld wget net-snmp net-snmp-utils mariadb-server 2&> $BASEDIR/log_packet_install.log
# yum install -y --disablerepo="*" --enablerepo="localrepo" httpd-tools httpd mod_auth_form-2.05-1.eon.x86_64 libxslt php-common php-mysql php php-xml php-xmlrpc php-ldap 2&>> $BASEDIR/log_packet_install.log

TZONE=`ls -l /etc/localtime |awk -F "zoneinfo/" '{print $2}'`
sed -i "s,^;date.timezone.*,date.timezone = \"${TZONE}\",g" /etc/php.ini
sed -i 's/^Defaults    requiretty/#Defaults    requiretty/g' /etc/sudoers
echo -e "\n# eorweb\napache ALL=NOPASSWD:/bin/systemctl * docker,/bin/systemctl * pentaho,/bin/systemctl * ,/bin/systemctl * snmpd,/bin/systemctl * wildfly" >> /etc/sudoers

#Installation Docker
mkdir /usr/bin/install_docker
cp $BASEDIR/CORE/dockers/docker-1.11.0.tar /usr/bin/install_docker
cd /usr/bin/install_docker
tar xvf ./docker-1.11.0.tar
mv ./docker/* /usr/bin/
rm -rf /usr/bin/install_docker

cp $BASEDIR/CORE/dockers/docker.service /etc/systemd/system
systemctl daemon-reload
systemctl enable docker

yes | cp $BASEDIR/CORE/config /etc/systemd/system/multi-user.target.wants/mariadb.service
systemctl daemon-reload

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
echo 'EyesOfReport website : http://www.eyesofnetwork.com/' >> /etc/issue
echo '' >> /etc/issue
######### VERSION ##########

cd /srv/eyesofreport/

mkdir -p ./configuration
cp $BASEDIR/CONF/eyesofreport.sh ./configuration

echo "Extracting Java archive..."
tar xvzf $BASEDIR/CORE/jdk-7u80-linux-x64.tar.gz > /dev/null
ln -s /srv/eyesofreport/jdk1.7.0_80 /srv/eyesofreport/java
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
#if [ $(rpm -qa | grep -c expect) -eq 0  ]; then
#    echo "Can't find expect. Trying install it..."
#    yum install -y --disablerepo="*" --enablerepo="localrepo"  expect >> /dev/null
#fi

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

#if [ $(MYSQL_PWD=root66 mysql -e "select user from mysql.user where user = 'eyesofreport' and host = '%'" | grep -c eyesofreport) -eq 0 ]; then
#	echo "CREATE USER 'eyesofreport'@'%' IDENTIFIED BY 'SaintThomas,2014'" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot
#fi

#if [ $(MYSQL_PWD=root66 mysql -e "select user from mysql.user where user = 'root' and host = '%'" | grep -c root) -eq 0 ]; then
#	echo "CREATE USER 'root'@'%' IDENTIFIED BY 'SaintThomas,2014'" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot
#fi

#Grant privileges to eyesofreport user
echo "GRANT ALL PRIVILEGES on global_nagiosbp.* to 'eyesofreport'@'localhost';" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot
#echo "GRANT ALL PRIVILEGES on global_nagiosbp.* to 'eyesofreport'@'%';" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot
#echo "GRANT ALL PRIVILEGES on global_nagiosbp.* to 'root'@'%';" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot
echo "GRANT ALL PRIVILEGES on thruk.* to 'eyesofreport'@'localhost';" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot
#echo "GRANT ALL PRIVILEGES on thruk.* to 'eyesofreport'@'%';" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot
#echo "GRANT ALL PRIVILEGES on thruk.* to 'root'@'%';" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot
echo "GRANT ALL PRIVILEGES on eor_ods.* to 'eyesofreport'@'localhost';" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot
#echo "GRANT ALL PRIVILEGES on eor_ods.* to 'eyesofreport'@'%';" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot
#echo "GRANT ALL PRIVILEGES on eor_ods.* to 'root'@'%';" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot
echo "GRANT ALL PRIVILEGES on eor_dwh.* to 'eyesofreport'@'localhost';" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot
#echo "GRANT ALL PRIVILEGES on eor_dwh.* to 'eyesofreport'@'%';" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot
#echo "GRANT ALL PRIVILEGES on eor_dwh.* to 'root'@'%';" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot
echo "GRANT ALL PRIVILEGES on eyesofreport.* to 'eyesofreport'@'localhost';" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot
#echo "GRANT ALL PRIVILEGES on eyesofreport.* to 'eyesofreport'@'%';" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot
#echo "GRANT ALL PRIVILEGES on eyesofreport.* to 'root'@'%';" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot
echo "GRANT ALL PRIVILEGES on bp_group_lilac.* to 'eyesofreport'@'localhost';" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot
#echo "GRANT ALL PRIVILEGES on bp_group_lilac to 'eyesofreport'@'%';" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot
#echo "GRANT ALL PRIVILEGES on bp_group_lilac.* to 'root'@'%';" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot

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
#echo "TRUNCATE TABLE d_time_dimension;" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot eor_dwh
echo "Time dimension index creation : this step should take a few time"
#echo "CALL fill_date_dimension('2014-10-01 00:00:00','2017-01-01 00:00:00');" | MYSQL_PWD=$NEW_MYSQL_PASSWORD mysql -uroot eor_dwh
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

$BASEDIR/WEB/install_web_Redhat.sh

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
