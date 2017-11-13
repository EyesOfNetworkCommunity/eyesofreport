echo "Eyes Of Report source transfert configuration :"

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

chmod +x $BASEDIR/setSourceVariable.sh
source $BASEDIR/setSourceVariable.sh

	echo "SSH connection testing for eyesofreport@$eor_address on port $eor_ssh_port..."
	su - eyesofreport -c "ssh -q -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null eyesofreport@$eor_address -p $eor_ssh_port exit"
	ssh_status=$?
	ssh_continue=1
	if [ ! $ssh_status -eq 0 ]; then
		echo -e "SSH connection error code $ssh_status	\e[31m[FAILED] \e[39m"
	fi

update_or_create=0	
source_path=/srv/eyesofreport/transfert/${source_name}
if [ -d "$source_path" ]; then
	echo "Update existing source"
	update_or_create=1
else 
	echo "Create new source"
	update_or_create=0
fi
	
	
	if [ $update_or_create -eq 0 ]; then

		case $source_name in
			* ) ;;
			[^a-zA-Z0-9\ ]* ) echo "Source name must contains only alphanumeric without space or special character";exit 1;;
		esac
		
		mkdir -p $source_path

	else
		case $source_name in
			* ) ;;
			[^a-zA-Z0-9\ ]* ) echo "Source name must contains only alphanumeric without space or special character";exit 1;;
		esac
	fi
	
	######################## CONFIGURATION LOG NAGIOS TRANSFERT ############################	
	if [ $configure_nagios_source -eq 1 ]; then
		
		transfert_nagios_command="/usr/bin/rsync -avr --rsh=\"/usr/bin/ssh -p \$2 \" \`/usr/bin/find $nagios_log_path -type f -mtime -2\`  eyesofreport@\$1:/home/eyesofreport/external_depot/Log_Nagios_Depot/"
		cron_command="eyesofreport $source_path/transfert_nagios_log.sh $eor_address $eor_ssh_port "
		#	echo -e "cron command : $cron_command"
	
		nagios_continue=1
		while [ -n "$(cat /etc/crontab | grep -n -m 1 "transfert_nagios_log.sh $eor_address $eor_ssh_port" | awk -F ":" '{print $1}')" ]; 
		do
			myLine=$(cat /etc/crontab | grep -n -m 1 "transfert_nagios_log.sh $eor_address $eor_ssh_port" | awk -F ":" '{print $1}')
			sed -i -e "$myLine"'d' /etc/crontab
		done

		if [ $nagios_continue -eq 1 ]; then
			cron_line="0 1 * * * $cron_command >> $source_path/log_transfert_nagios_log"
			echo "$cron_line" >> /etc/crontab
			echo "$transfert_nagios_command" > $source_path/transfert_nagios_log.sh
			chmod +x $source_path/transfert_nagios_log.sh
			chown -R eyesofreport:wheel $source_path
			echo -e "Transfert scheduling for log nagios ($nagios_log_path) in /etc/crontab	 \e[92m[OK] \e[39m"
		fi
	else echo -e "Eyes of Report Source : Nagios log transfert scheduling :	\e[33m[SKIPPED] \e[39m"
	fi
	
	######################## CONFIGURATION NAGIOS BP TRANSFERT ############################

	if [ $configure_nagios_bp_source -eq 1 ]; then
	
		transfert_nagios_bp_command="/usr/bin/rsync -avr --rsh=\"/usr/bin/ssh -p \$2 \" \`/usr/bin/find $nagios_bp_log_path -type f -mtime -2\`  eyesofreport@\$1:/home/eyesofreport/external_depot/Nagios_BP_Depot/"
		cron_command="eyesofreport $source_path/transfert_nagios_bp.sh $eor_address $eor_ssh_port "
		#	echo -e "cron command : $cron_command"
	
		nagiosbp_continue=1
		while [ -n "$(cat /etc/crontab | grep -n -m 1 "transfert_nagios_bp.sh $eor_address $eor_ssh_port" | awk -F ":" '{print $1}')" ]; 
		do
			myLine=$(cat /etc/crontab | grep -n -m 1 "transfert_nagios_bp.sh $eor_address $eor_ssh_port" | awk -F ":" '{print $1}')
			sed -i -e "$myLine"'d' /etc/crontab
		done

		if [ $nagiosbp_continue -eq 1 ]; then
			cron_line="0 1 * * * $cron_command >> $source_path/log_transfert_nagiosbp"
			echo "$cron_line" >> /etc/crontab
			echo "$transfert_nagios_bp_command" > $source_path/transfert_nagios_bp.sh
			chmod +x $source_path/transfert_nagios_bp.sh
			chown -R eyesofreport:wheel $source_path
			echo -e "Transfert scheduling for nagios bp ($nagios_bp_log_path) in /etc/crontab	 \e[92m[OK] \e[39m"
		fi
	else echo -e "Eyes of Report Source : Nagios bp transfert scheduling :	\e[33m[SKIPPED] \e[39m"
	fi
	
	######################## CONFIGURATION GED TRANSFERT ############################
	configure_ged_source=1
	
	if [ $configure_ged_source -eq 1 ]; then
		
		
		transfert_ged_command="/usr/bin/rsync -avr --rsh=\"/usr/bin/ssh -p \$2 \" \`/usr/bin/find $nagios_ged_path -type f -mtime -2\`  eyesofreport@\$1:/home/eyesofreport/external_depot/Ged_Depot/"
		cron_command="eyesofreport $source_path/transfert_ged.sh $eor_address $eor_ssh_port "
		#	echo -e "cron command : $cron_command"
	
		ged_continue=1
		while [ -n "$(cat /etc/crontab | grep -n -m 1 "transfert_ged.sh $eor_address $eor_ssh_port" | awk -F ":" '{print $1}')" ]; 
		do
			myLine=$(cat /etc/crontab | grep -n -m 1 "transfert_ged.sh $eor_address $eor_ssh_port" | awk -F ":" '{print $1}')
			sed -i -e "$myLine"'d' /etc/crontab
		done

		if [ $ged_continue -eq 1 ]; then
			cron_line="0 1 * * * $cron_command >> $source_path/log_transfert_ged"
			echo "$cron_line" >> /etc/crontab
			echo "$transfert_ged_command" > $source_path/transfert_ged.sh
			chmod +x $source_path/transfert_ged.sh
			chown -R eyesofreport:wheel $source_path
			echo -e "Transfert scheduling for ged ($nagios_ged_path) in /etc/crontab	 \e[92m[OK] \e[39m"
		fi
	else echo -e "Eyes of Report Source : Ged transfert scheduling :	\e[33m[SKIPPED] \e[39m"
	fi
	
	######################## CONFIGURATION Lilac TRANSFERT ############################
	
	if [ $configure_lilac_source -eq 1 ]; then
		
		transfert_lilac_command="/usr/bin/rsync -avr --rsh=\"/usr/bin/ssh -p \$2 \" \`/usr/bin/find $nagios_lilac_path -type f -mtime -2\`  eyesofreport@\$1:/home/eyesofreport/external_depot/Lilac_Depot/"
		cron_command="eyesofreport $source_path/transfert_lilac.sh $eor_address $eor_ssh_port "
		#	echo -e "cron command : $cron_command"
	
		lilac_continue=1
		while [ -n "$(cat /etc/crontab | grep -n -m 1 "transfert_lilac.sh $eor_address $eor_ssh_port" | awk -F ":" '{print $1}')" ]; 
		do
			myLine=$(cat /etc/crontab | grep -n -m 1 "transfert_lilac.sh $eor_address $eor_ssh_port" | awk -F ":" '{print $1}')
			sed -i -e "$myLine"'d' /etc/crontab
		done

		if [ $lilac_continue -eq 1 ]; then
			cron_line="0 1 * * * $cron_command >> $source_path/log_transfert_lilac"
			echo "$cron_line" >> /etc/crontab
			echo "$transfert_lilac_command" > $source_path/transfert_lilac.sh
			chmod +x $source_path/transfert_lilac.sh
			chown -R eyesofreport:wheel $source_path
			echo -e "Transfert scheduling for lilac ($nagios_lilac_path) in /etc/crontab	 \e[92m[OK] \e[39m"
		fi
	else echo -e "Eyes of Report Source : Lilac transfert scheduling :	\e[33m[SKIPPED] \e[39m"
	fi
	

	
	

