
#!/bin/bash

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Eyes of report ETL brick creation"


pentaho_port=8181

firewall-cmd --zone=public --add-port=$pentaho_port/tcp --permanent > /dev/null
echo -e "Opening $pentaho_port port on firewalld for pentaho webservice	 \e[92m[OK] \e[39m"
firewall-cmd --reload > /dev/null
echo -e "Reload firewalld \e[92m[OK] \e[39m"

installation_path=$BASEDIR
pentaho_path=/srv/eyesofreport/etl
injection_folder=injection
log_file=$pentaho_path/installation_log
MYSQL_ROOT=root66

source $BASEDIR/../CONF/eyesofreport.sh
source $BASEDIR/../CONF/convert_env_variables.sh

MYSQL_EOR=$EOR_DATABASE_PWD

if [ ! -d /var/log/pentaho ]; then
	mkdir -p /var/log/pentaho
fi

if [ -d "$pentaho_path" ]; then
	while true; do
		read -p "ETL environment already exists (/srv/eyesofreport/etl). Remove it ? (y/n)" yn
		case $yn in
			[Yy]* ) rm -rf $pentaho_path;mkdir -p $pentaho_path;break;;
			[Nn]* ) exit;;
			* ) echo "Please answer y or n.";;
		esac
	done
else mkdir -p $pentaho_path
	 mkdir -p $pentaho_path/$injection_folder
fi

cd $installation_path
echo "Extract ETL brick archive..."
#tar xvf $installation_path/Install_Files.tar > /dev/null

cp $installation_path/data-integration.zip $pentaho_path
#cp $installation_path/data-integration-eor.tar $pentaho_path
cp -r $installation_path/data-integration-eor $pentaho_path
#cp $installation_path/Host_ETL_Env.tar $pentaho_path
cp -r $installation_path/Host_ETL_Env/* $pentaho_path

cd $pentaho_path
echo "Extract data integration archive..."
unzip $pentaho_path/data-integration.zip > /dev/null
cp $pentaho_path/data-integration-eor/init_carte_pwd.sh $pentaho_path/data-integration
cp $pentaho_path/data-integration-eor/jdbc_model.properties $pentaho_path/data-integration/simple-jndi/
cp $pentaho_path/data-integration-eor/mysql-connector-java-5.1.35-bin.jar $pentaho_path/data-integration/lib/
cp $pentaho_path/data-integration-eor/pentaho.service $pentaho_path/data-integration
cp $pentaho_path/data-integration-eor/start_carte.sh $pentaho_path/data-integration
cp $pentaho_path/data-integration-eor/carte_config.xml $pentaho_path/data-integration

cd $pentaho_path/validator
sed -i "s/EOR_DATABASE/$EOR_DATABASE_IP/g" $pentaho_path/validator/AppliAvailabilityCompute.properties 
sed -i "s/EOR_DB_USER/$EOR_DATABASE_USER/g" $pentaho_path/validator/AppliAvailabilityCompute.properties
sed -i "s/EOR_DB_PWD/$EOR_DATABASE_PWD/g" $pentaho_path/validator/AppliAvailabilityCompute.properties
zip ./ETL_DTM_COMPUTE_STATE_JAR.jar ./AppliAvailabilityCompute.properties > /dev/null

sed -i "s/EOR_DATABASE/$EOR_DATABASE_IP/g" $pentaho_path/validator/AppliLinkAnalysis.properties 
sed -i "s/EOR_DB_USER/$EOR_DATABASE_USER/g" $pentaho_path/validator/AppliLinkAnalysis.properties
sed -i "s/EOR_DB_PWD/$EOR_DATABASE_PWD/g" $pentaho_path/validator/AppliLinkAnalysis.properties
zip ./ETL_RAW_APPLICATION_LINK_ANALYSIS.jar ./AppliLinkAnalysis.properties > /dev/null

yes | rm $pentaho_path/data-integration.zip
yes | rm -rf $pentaho_path/data-integration-eor

cd /root
if [ -d /root/.kettle ]; then
	tar cvf /root/kettle.tar /root/.kettle > /dev/null
	yes | mv /root/kettle.tar /tmp
	echo "Old kettle configuration saved in /tmp/kettle.tar"
	rm -rf /root/.kettle
fi
cp -r $installation_path/.kettle /root

#clean installation folder
#rm $installation_path/convertPentahoEnvVariables.sh
#rm $installation_path/data-integration.zip
#rm $installation_path/Host_ETL_Env
#rm $installation_path/kettle.tar
#rm $installation_path/data-integration-eor.tar

echo -e "ETL Environment \e[92m[OK] \e[39m"

cd $pentaho_path/

#data integration configuration
cp $pentaho_path/data-integration/simple-jndi/jdbc_model.properties $pentaho_path/data-integration/simple-jndi/jdbc.properties

sed -i "s/EOR_WEB_DATABASE_IP/$EOR_WEB_DATABASE_IP/g" $pentaho_path/data-integration/simple-jndi/jdbc.properties 
sed -i "s/EOR_WEB_DATABASE_USER/$EOR_WEB_DATABASE_USER/g" $pentaho_path/data-integration/simple-jndi/jdbc.properties 
sed -i "s/EOR_WEB_DATABASE_PWD/$EOR_WEB_DATABASE_PWD/g" $pentaho_path/data-integration/simple-jndi/jdbc.properties
sed -i "s/EOR_DATABASE_IP/$EOR_DATABASE_IP/g" $pentaho_path/data-integration/simple-jndi/jdbc.properties
sed -i "s/EOR_DATABASE_USER/$EOR_DATABASE_USER/g" $pentaho_path/data-integration/simple-jndi/jdbc.properties
sed -i "s/EOR_DATABASE_PWD/$EOR_DATABASE_PWD/g" $pentaho_path/data-integration/simple-jndi/jdbc.properties
sed -i "s/EOR_REPOSITORY_IP/$EOR_REPOSITORY_IP/g" $pentaho_path/data-integration/simple-jndi/jdbc.properties
sed -i "s/EOR_REPOSITORY_USER/$EOR_REPOSITORY_USER/g" $pentaho_path/data-integration/simple-jndi/jdbc.properties
sed -i "s/EOR_REPOSITORY_PWD/$EOR_REPOSITORY_PWD/g" $pentaho_path/data-integration/simple-jndi/jdbc.properties
sed -i "s/EOR_TECHNIC_DATABASE_IP/$EOR_TECHNIC_DATABASE_IP/g" $pentaho_path/data-integration/simple-jndi/jdbc.properties
sed -i "s/EOR_TECHNIC_DATABASE_USER/$EOR_TECHNIC_DATABASE_USER/g" $pentaho_path/data-integration/simple-jndi/jdbc.properties
sed -i "s/EOR_TECHNIC_DATABASE_PWD/$EOR_TECHNIC_DATABASE_PWD/g" $pentaho_path/data-integration/simple-jndi/jdbc.properties
sed -i "s/SLAVE_IP/$EOR_REPOSITORY_IP/g" /root/.kettle/kettle.properties

#IPADDR=$(ip add show `route -n | grep UG | awk '{print $8}'` | tr '\t' ' ' | sed -e 's:  : :g' | grep "^  inet " | awk '{print $2}' | cut -d '/' -f1)
IPADDR=127.0.0.1
#HOSTNAME=$(host $IPADDR | tail -1 | awk '{print $5}')
#if [ $(host $IPADDR | grep -c 'not found') -eq 0 ]; then
#	while true; do
#		read -p "Host name $HOSTNAME has been found for ip $IPADDR ? Do you want to use it for pentaho web service access (y/n)" yn
#		case $yn in
#			[Yy]* ) CARTE_HOST=$HOSTNAME;break;;
#			[Nn]* ) CARTE_HOST=$IPADDR;break;;
#			* ) echo "Please answer y or n.";;
#		esac
#	done
#else 
	CARTE_HOST=$IPADDR
#fi

CARTE_HOST=$(echo $CARTE_HOST | sed -e 's/\\/\\\\/g' -e 's/\./\\./g' -e 's/\//\\\//g' -e 's/\$/\\$/g' -e 's/\*/\\*/g' -e 's/\[/\\[/g' -e 's/\]/\\]/g' -e 's/\^/\\^/g')

sed -i "s/<hostname>.*<\/hostname>/<hostname>$CARTE_HOST<\/hostname>/g" $pentaho_path/data-integration/carte_config.xml

sed -i "s/CARTE_PWD/$CARTE_PWD/g" $pentaho_path/data-integration/init_carte_pwd.sh


source $BASEDIR/../CONF/eyesofreport.sh

chmod +x $pentaho_path/data-integration/*.sh && $pentaho_path/data-integration/init_carte_pwd.sh

pentaho_continue=1
		while [ -n "$(cat /etc/cron.d/eyesofreport | grep -n -m 1 "main_job.sh " | awk -F ":" '{print $1}')" ]; 
		do
			myLine=$(cat /etc/cron.d/eyesofreport | grep -n -m 1 "main_job.sh " | awk -F ":" '{print $1}')
			while true; do
				read -p "Main pentaho job is already scheduled in /etc/cron.d/eyesofreport on eyes of report server. Do you want to remove it ? (y/n)" yn
				case $yn in
					[Yy]* ) sed -i -e "$myLine"'d' /etc/cron.d/eyesofreport;break;;
					[Nn]* ) echo -e "Eyes of Report main job scheduling :	\e[33m[CANCELED] \e[39m";pentaho_continue=0;break;;
					* ) echo "Please answer y or n.";;
				esac
			done
		
			if [ $pentaho_continue -eq 0 ]; then
				break;
			fi

		done

		if [ $pentaho_continue -eq 1 ]; then
			echo "0 3 * * * root /srv/eyesofreport/etl/scripts/main_job.sh >> /srv/eyesofreport/etl/pdi_log/main_job" >> /etc/cron.d/eyesofreport
			chmod +x $pentaho_path/scripts/main_job.sh
			echo -e "Eyes of Report main job scheduling in /etc/cron.d/eyesofreport	 \e[92m[OK] \e[39m"
		fi
		
pentaho_continue=1
		while [ -n "$(cat /etc/cron.d/eyesofreport | grep -n -m 1 "keep_mysql_connection_alive.sh" | awk -F ":" '{print $1}')" ]; 
		do
			myLine=$(cat /etc/cron.d/eyesofreport | grep -n -m 1 "keep_mysql_connection_alive.sh" | awk -F ":" '{print $1}')
			while true; do
				read -p "Mysql connection keep alive transformation is already scheduled in /etc/cron.d/eyesofreport on eyes of report server. Do you want to remove it ? (y/n)" yn
				case $yn in
					[Yy]* ) sed -i -e "$myLine"'d' /etc/cron.d/eyesofreport;break;;
					[Nn]* ) echo -e "Mysql connection keep alive transformation scheduling :	\e[33m[CANCELED] \e[39m";pentaho_continue=0;break;;
					* ) echo "Please answer y or n.";;
				esac
			done
		
			if [ $pentaho_continue -eq 0 ]; then
				break;
			fi

		done

		if [ $pentaho_continue -eq 1 ]; then
			echo "0 */4 * * * root /srv/eyesofreport/etl/scripts/keep_mysql_connection_alive.sh >> /srv/eyesofreport/etl/pdi_log/keep_alive_mysql" >> /etc/cron.d/eyesofreport
			chmod +x $pentaho_path/scripts/keep_mysql_connection_alive.sh
			echo -e "Eyes of Report mysql keep alive connection scheduling in /etc/cron.d/eyesofreport	 \e[92m[OK] \e[39m"
		fi

#test if eor_repository database exists
test_db=$(MYSQL_PWD="$MYSQL_EOR" mysql -ueyesofreport -e 'show databases' | grep eor_repository)
drop_database=y
if [ "$test_db" == "eor_repository" ]; then
        while true; do
		read -p "Database eor_repository already exists. Do you want to drop it ? (y/n)" yn
		case $yn in
			[Nn]* ) drop_database=n;echo -e "Existing database eor_repository conserved	\e[92m[OK] \e[39m";break;;
			[Yy]* ) MYSQL_PWD="$MYSQL_EOR" mysqldump -ueyesofreport eor_repository > /tmp/eor_repository.sql; echo "eor_repository.sql dumped in /tmp"; MYSQL_PWD="$MYSQL_EOR" mysql -ueyesofreport -e "drop database eor_repository;";break;;
			* ) echo "Please answer y or n.";;
		esac
	done
fi
if [ "$drop_database" == "y" ]; then 
#generate database user + mdp
	echo "CREATE DATABASE eor_repository;" | MYSQL_PWD=$MYSQL_ROOT mysql -uroot  -h$EOR_REPOSITORY_IP 
	MYSQL_PWD=$MYSQL_ROOT mysql -uroot -h$EOR_REPOSITORY_IP eor_repository < $installation_path/eor_repository.sql
	echo "GRANT ALL PRIVILEGES on eor_repository.* to 'eyesofreport'@'%'" | MYSQL_PWD=$MYSQL_ROOT mysql -uroot  -h$EOR_REPOSITORY_IP 
	echo "GRANT ALL PRIVILEGES on eor_repository.* to 'eyesofreport'@'localhost'" | MYSQL_PWD=$MYSQL_ROOT mysql -uroot  -h$EOR_REPOSITORY_IP
	echo -e "database eor_repository created	\e[92m[OK] \e[39m"
fi		
		
		
#rm $installation_path/eor_repository.sql		
yes | cp $pentaho_path/data-integration/pentaho.service /etc/systemd/system/

chmod -R +x $pentaho_path/

systemctl enable pentaho.service 
systemctl enable crond


exit 0
