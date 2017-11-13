#!/bin/bash

#if [ -z "$1" ]
#  then
#    echo "Usage : generate_nagios_source.sh source_trigram (eg. ma1 for marignane)"
#	echo "	source_trigram : source indentification trigram (e.g. ma1 for marignane)"
#	exit
#fi

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#if [ ! -f "${BASEDIR}/centos_ssh/id_rsa.pub" ]
#  then
#    echo "Usage : You must place in generate_nagios_source folder id_rsa.pub file which contains ssh user public key generated on log nagios sender host"
#	exit
#fi

source_name=defaut
source_description=defaut
source_trigram=defaut
site_trigram=defaut
eyesofreport_ip_name=192.168.26.128
type_source=defaut

echo "Eyes of report source reception creation"

while true; do
	read -p "Type of source (1:EON 2:Nagios) : " type_source
	if [ -z "$type_source" ]; then
		echo "Type of source can't be empty"
	else	
		case $type_source in
			[1] ) type_source=eon;break;;
			[2] ) type_source=nag;break;;
			* ) echo "Please type 1 for EON source, 2 for Nagios standalone source";;
		esac
	fi
done

flag_ged=0
flag_lilac=0
flag_nagiosbp=1

if [ "$type_source" == "eon" ]; then
	flag_ged=1
	flag_lilac=1
	flag_nagiosbp=1
fi

source_erase=0
while true; do
	read -p "Name of the source (mandatory) : " source
	if [ -z "$source" ]; then
		echo "Source name can't be empty"
	else	
		test_exist=$(MYSQL_PWD="SaintThomas,2014" mysql -ueyesofreport -e 'SELECT name FROM global_nagiosbp.bp_sources;' | grep $source$)
		if [ -z "$test_exist" ]; then
			case $source in
				* ) source_name=$source;break;;
				[^a-zA-Z0-9\ ]* ) echo "Please type only alphanumeric without space or special character";;
			esac
		else read -p "The source already exist in eyesofreport system. Do you want to erase it ? (y/n) " yn
			case $yn in
				[Yy]* ) source_erase=1;source_name=$source;MYSQL_PWD="SaintThomas,2014" mysql -ueyesofreport -e "DELETE FROM global_nagiosbp.bp_sources where name = '$source'; ";break;;
				[Nn]* ) exit 0;;
			esac	
		fi
	fi
done

while true; do
	read -p "Description of the source (optional) : " description
	if [ -z "$description" ]; then
		description="NA"
	fi
	case $description in
		* ) source_description=$description;break;;
		[^a-zA-Z0-9\ ]* ) echo "Please type only alphanumeric without space or special character";;
	esac
	
done

while true; do
	read -p "Source identification trigram, no upper letters and numeric (mandatory) : " trigram
	size=$(expr length $trigram)
	if [ ! $size -eq 3 ]; then
		echo -e "A trigram contains 3 characters. Visit https://en.wikipedia.org/wiki/Trigram for more information \e[92m:p \e[39m"
	else
		case $trigram in
			* ) source_trigram=$trigram;break;;
			[^a-z\ ]* ) echo "Please type only alpha caracters without space or special character or upper characters";;
		esac
	fi
done

while true; do
	read -p "Host site identification trigram, no upper letters and numeric(mandatory) : " trigram_site
	size=$(expr length $trigram_site)
	if [ ! $size -eq 3 ]; then
		echo -e "Host site identification trigram must contains only 3 characters"
	else
		case $trigram_site in
			* ) site_trigram=$trigram_site;break;;
			[^a-z\ ]* ) echo "Please type only alpha caracters without space or special character or upper characters";;
		esac
	fi
done

source_nagios_path=/srv/eyesofreport/docker_script/centos_nagios_${site_trigram}_${source_trigram}
installation_path=$BASEDIR

if [ -d $source_nagios_path ]; then
	while true; do
		read -p "Nagios containers folder for ${site_trigram}_${source_trigram} already exist. Would you remove it ? (y/n)" yn
		case $yn in
			[Yy]* ) rm -rf $source_nagios_path;break;;
			[Nn]* ) exit;;
			* ) echo "Please answer y or n.";;
		esac
	done
fi

mkdir -p $source_nagios_path

#creation of the container share environment
share=/srv/eyesofreport/source/${site_trigram}_${source_trigram}
if [ -d $share/Log_Nagios ]; then
	while true; do
		read -p "A share environment for ${source_trigram} already exists. Do you want to keep it ? If no /Log_Nagios and /Archives will be removed (y/n)" yn
		case $yn in
			[Nn]* ) rm -rf $share/*; mkdir -p $share/Log_Nagios; mkdir -p $share/Archives; mkdir -p $share/Nagios_BP; mkdir -p $share/Ged; mkdir -p $share/Lilac; break;;
			[Yy]* ) break;;
			* ) echo "Please answer y or n.";;
		esac
	done
else 
	mkdir -p $share/Log_Nagios
	mkdir -p $share/Archives
	mkdir -p $share/Nagios_BP
	mkdir -p $share/Ged
	mkdir -p $share/Lilac
fi

echo -e "Container share environment ${site_trigram}_${source_trigram} creation	\e[92m[OK] \e[39m"

#SSH Configuration
echo "SSH Configuration :"
test_site_exist=$(MYSQL_PWD="SaintThomas,2014" mysql -ueyesofreport -e 'SELECT distinct trigram_site FROM global_nagiosbp.bp_sources;' | grep $site_trigram)
use_existing_public_key=n
if [ "$test_site_exist" == "$site_trigram" ];then
	while true; do
		read -p " One or more sources linked to $site_trigram are connected to Eyes of report. Press 'y' if you will use a machine with ssh already configured to transfert data on eyesofreport server (else type 'n') :  " yn
		case $yn in
			[Yy]*) use_existing_public_key=y;break;;
			[Nn]*) use_existing_public_key=n;break;;
			*) echo "Please type y or n";;
		esac
	done
fi

host_name=defaut
private_key=default
public_key=default
if [ "$use_existing_public_key" == "y" ]; then
	echo "List of connected machine for site $site_trigram :"
	MYSQL_PWD="SaintThomas,2014" mysql -ueyesofreport -e 'SELECT distinct host_source FROM global_nagiosbp.bp_sources;' | tail -n +2
	while true; do
		read -p "Enter one of machine listed above you want to use to load source data to Eyes of report server : " host_name
		test_site_exist=$(MYSQL_PWD="SaintThomas,2014" mysql -ueyesofreport -e "SELECT distinct host_source FROM global_nagiosbp.bp_sources WHERE host_source = '$host_name';" | grep $host_name)
		if [ -z "$test_site_exist" ]; then
			echo "You typed a non existing machine"
		else break;
		fi
	done
	
	public_key=$(MYSQL_PWD="SaintThomas,2014" mysql -ueyesofreport -e "SELECT distinct host_source_public_key FROM global_nagiosbp.bp_sources WHERE host_source = '$host_name';" | tail -n +2)
	if [ -z "$public_key" ]; then
		echo "No public key associated to host $host_name. Please contact hotline to solve these problem"
		exit 1
	fi
	
	private_key=$(MYSQL_PWD="SaintThomas,2014" mysql -ueyesofreport -e "SELECT distinct host_source_private_key FROM global_nagiosbp.bp_sources WHERE host_source = '$host_name';" | tail -n +2)
	if [ -z "$private_key" ]; then
		echo "No private key associated to host $host_name. Please contact hotline to solve these problem"
		exit 1
	fi
	
		echo $public_key > ${BASEDIR}/centos_ssh/id_dsa.pub
else
	

	read -p "Enter host machine dns name or ip which will send data to eyesofreport : " host_name

	ssh_folder=/tmp
	file=$ssh_folder/id_dsa
	if [ -f $file ]; then
			rm -f $file
	fi
	file=$ssh_folder/id_dsa.pub
	if [ -f $file ]; then
			rm -f $file
	fi

	ssh_name=eyesofreport@$host_name
	ssh-keygen -N '' -f /tmp/id_dsa -t dsa -C "$ssh_name" -I eyesofreportkey
	
	yes | cp /tmp/id_dsa ${BASEDIR}/centos_ssh/
	yes | cp /tmp/id_dsa.pub ${BASEDIR}/centos_ssh/
	
	public_key=$(cat /tmp/id_dsa.pub)
	private_key=$(cat /tmp/id_dsa)
fi

port=$(MYSQL_PWD="SaintThomas,2014" mysql -ueyesofreport -e 'SELECT case when max(ssh_port) is null then 22000 else max(ssh_port) + 1 end as port FROM global_nagiosbp.bp_sources;' | tail -n +2)

while true; do
		read -p "Default ssh port for source transfert will be $port. Press enter to keep it or type another port [22000 - 23000] : " user_port
		re='^[0-9]+$'
		if [ ! -z "$user_port" ]; then
			test_port_exist=$(MYSQL_PWD="SaintThomas,2014" mysql -ueyesofreport -e 'SELECT ssh_port FROM global_nagiosbp.bp_sources;' | grep $user_port)
			if [ "$test_port_exist" == "$user_port" ]; then
				echo "Port already using"
			else
				if [ "$(echo $user_port | grep "^[ [:digit:] ]*$")" ]; then 
					port_divided=$(expr $user_port / 1000 )
					case $port_divided in
							22) port=$user_port; break;;
							*) echo "Please type port between 22000 and 23000";;
					esac
				else echo "Please type digit only"
				fi
			fi
		else break
		fi
done

#build tar which contains source machine configuration scripts
site_source=${site_trigram}_${source_trigram}

HOST_ID=defaut
IPADDR=$(ip add show `route -n | grep UG | awk '{print $8}'` | tr '\t' ' ' | sed -e 's:  : :g' | grep "^  inet " | awk '{print $2}' | cut -d '/' -f1)
#HOSTNAME=$(host $IPADDR | tail -1 | awk '{print $5}')
#if [ $(host $IPADDR | grep -c 'not found') -eq 0 ]; then
#	while true; do
#		read -p "Host name $HOSTNAME has been found for ip $IPADDR ? Do you want to use it for pentaho web service access (y/n)" yn
#		case $yn in
#			[Yy]* ) HOST_ID=$HOSTNAME;break;;
#			[Nn]* ) HOST_ID=$IPADDR;break;;
#			* ) echo "Please answer y or n.";;
#		esac
#	done
#else 
	HOST_ID=$IPADDR
#fi

HOST_ID=$(echo $HOST_ID | sed -e 's/\\/\\\\/g' -e 's/\./\\./g' -e 's/\//\\\//g' -e 's/\$/\\$/g' -e 's/\*/\\*/g' -e 's/\[/\\[/g' -e 's/\]/\\]/g' -e 's/\^/\\^/g')


cp $BASEDIR/centos_ssh/setSourceVariableGeneric.sh $BASEDIR/centos_ssh/setSourceVariable.sh 
variable_file=setSourceVariable.sh

sed -i "s/V_EOR_ADDRESS/$HOST_ID/g" $BASEDIR/centos_ssh/setSourceVariable.sh
sed -i "s/V_EOR_PORT/$port/g" $BASEDIR/centos_ssh/setSourceVariable.sh
sed -i "s/V_SOURCE_NAME/$site_source/g" $BASEDIR/centos_ssh/setSourceVariable.sh

if [ "$use_existing_public_key" == "y" ]; then
	tar cvzf ${BASEDIR}/install_source.tar.gz -C ${BASEDIR}/centos_ssh/ source_transfert_scheduling.sh source_transfert_scheduling_silent.sh setSourceVariable.sh > /dev/null
else
	tar cvzf ${BASEDIR}/install_source.tar.gz -C ${BASEDIR}/centos_ssh/ source_transfert_scheduling.sh source_transfert_scheduling_silent.sh source_ssh_initialisation.sh id_dsa id_dsa.pub setSourceVariable.sh > /dev/null
fi

yes | rm ${BASEDIR}/centos_ssh/setSourceVariable.sh

livestatus_code=defaut
#generate thruk livestatus backend id
while true; do
	number=$RANDOM
	RANGE=9999
	let "number %= $RANGE"
	livestatus_code=${number}b

	if [ "$number" -gt 1000 ]; then
		test_exist=$(MYSQL_PWD="SaintThomas,2014" mysql -ueyesofreport -e 'SELECT thruk_idx FROM global_nagiosbp.bp_sources;' | grep $livestatus_code)
		if [ ! -z "$test_exist" ]; then
			if [ ! "$livestatus_code" == "$test_exist" ]; then
				MYSQL_PWD="SaintThomas,2014" mysql -ueyesofreport -e "INSERT INTO global_nagiosbp.bp_sources (db_names,nick_name,thruk_idx,name,description,type_source,trigram_source,ssh_port,container_ssh,container_nagios,trigram_site,host_source,host_source_public_key,host_source_private_key,flag_nagiosbp,flag_lilac,flag_ged,flag_thruk) values ('${site_source}_nagiosbp','$site_source','$livestatus_code','$source_name','$source_description','$type_source','$source_trigram',$port,'centos_ssh_$site_source','centos_nagios_$site_source','$trigram_site','$host_name','$public_key','$private_key',$flag_nagiosbp,$flag_lilac,$flag_ged,1);"
				break
			fi
		else
			MYSQL_PWD="SaintThomas,2014" mysql -ueyesofreport -e "INSERT INTO global_nagiosbp.bp_sources (db_names,nick_name,thruk_idx,name,description,type_source,trigram_source,ssh_port,container_ssh,container_nagios,trigram_site,host_source,host_source_public_key,host_source_private_key,flag_nagiosbp,flag_lilac,flag_ged,flag_thruk) values ('${site_source}_nagiosbp','$site_source','$livestatus_code','$source_name','$source_description','$type_source','$source_trigram',$port,'centos_ssh_$site_source','centos_nagios_$site_source','$trigram_site','$host_name','$public_key','$private_key',$flag_nagiosbp,$flag_lilac,$flag_ged,1);"
			break
		fi
	fi
	
done

$installation_path/centos_ssh/generate_ssh_container.sh $source_trigram $site_trigram $port

OUT=$?
if [ ! $OUT -eq 0 ];then
   echo -e "SSH container $container_name creation 	\e[31m[FAILED] \e[39m"
   echo -e "Nagios source $source_trigram creation	\\e[31m[FAILED] \e[39m"
   exit 1
fi

echo "Try send tar Eyes Of Report source installation on source machine (/tmp/install_source.tar.gz)..."
$BASEDIR/send_source_install_folder.sh $host_name
OUT=$?
if [ ! $OUT -eq 0 ];then
   echo -e "SSH Installation Folder client sending 	\e[31m[FAILED] \e[39m"
   echo -e "INFO : Please verify $host_name is up and rsync correctly installed. For manual installation, copy on $host_name $BASEDIR/remote_intall folder and execute completeInstallClient.sh script \e[39m"
   exit 1
fi


$installation_path/centos_nagios/generate_nagios_container.sh $source_trigram $site_trigram $livestatus_code

OUT=$?
if [ ! $OUT -eq 0 ];then
	echo -e "SSH container $container_name creation 	\e[31m[FAILED] \e[39m"
	exit 1
else 
	echo -e "Nagios source $source_trigram creation	\e[92m[SUCCESS] \e[39m"

fi

exit 0
