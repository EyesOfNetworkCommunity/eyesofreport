echo "Eyes Of Report source transfert configuration :"

	read -p "Enter eyes of report server name or ip address : " eor_address
	read -p "Enter eyes of report ssh port : " eor_ssh_port
	echo "SSH connection testing for eyesofreport@$eor_address on port $eor_ssh_port..."
	echo - e "WARNING : Don't forget to connect one time from $eor_address to Eyesofreport host to add it as knew host \e[39m"
	su - eyesofreport -c "ssh -q -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null eyesofreport@$eor_address -p $eor_ssh_port exit"
	ssh_status=$?
	ssh_continue=1
	if [ ! $ssh_status -eq 0 ]; then
		echo -e "SSH connection error code $ssh_status	\e[31m[FAILED] \e[39m"
		while true; do
			read -p "Do you want to continue anyway ? (y/n)" fail_continue
			case $fail_continue in
				[Yy]* ) ssh_continue=1;break;;
				[Nn]* ) ssh_continue=0;break;;
				* ) echo "Please answer y or n.";;
			esac
		done
	else echo -e "SSH connection successful	\e[92m[OK] \e[39m"
	fi
	
	if [ $ssh_continue -eq 0 ]; then
		exit 1;
	fi
	
	#0 for create, 1 for update
	update_or_create=0
	while true; do
		read -p "Do you want to create a new source or update an existing source ? (type 'c' for create, 'u' for update, 'o' to display existing sources): " uc
		if [ -d /srv/eyesofreport/transfert ]; then	
			case $uc in
				[Uu]* ) update_or_create=1;break;;
				[Cc]* ) update_or_create=0;break;;
				[Oo]* ) ls /srv/eyesofreport/transfert;;
				* ) echo "Please answer c or u.";;
			esac
		else
			case $uc in
				[Uu]* ) update_or_create=1;break;;
				[Cc]* ) update_or_create=0;break;;
				[Oo]* ) echo "No existing source";;
				* ) echo "Please answer c or u.";;
			esac
		fi
		
	done
	
	source_name=defaut
	source_path=defaut
	if [ $update_or_create -eq 0 ]; then
		while true; do
			read -p "Name of your new source : " source
			case $source in
				* ) source_name=$source;break;;
				[^a-zA-Z0-9\ ]* ) echo "Please type only alphanumeric without space or special character";;
			esac
		done
		
		source_path=/srv/eyesofreport/transfert/${source_name}
		if [ -d  $source_path ]; then
			echo "Source ${source_name} already exists (folder $source_path). Choose update to change existing source."
			echo -e "Eyes of report source configuration	\e[31m[EXITED] \e[39m"
			exit 1;
		else mkdir -p $source_path
		fi
	else
		while true; do
			read -p "Name of existing source : " source
			case $source in
				* ) source_name=$source;break;;
				[^a-zA-Z0-9\ ]* ) echo "Please type only alphanumeric without space or special character";;
			esac
		done
		
		source_path=/srv/eyesofreport/transfert/${source_name}
		if [ ! -d  $source_path ]; then
			echo "Source ${source_name} doesn't exist (missing folder $source_path). Choose choose create to add a new source."
			echo -e "Eyes of report source configuration	\e[31m[EXITED] \e[39m"
			exit 1;
		fi
	fi
	
	######################## CONFIGURATION LOG NAGIOS TRANSFERT ############################
	configure_nagios_source=1
	while true; do
		read -p "1: Nagios log transfert configuration. Skip this step ? (y/n) " yn
		case $yn in
			[Nn]* ) configure_nagios_source=1;break;;
			[Yy]* ) configure_nagios_source=0;break;;
			* ) echo "Please answer y or n.";;
		esac
	done
	
	if [ $configure_nagios_source -eq 1 ]; then
		read -p "Enter absolute path of nagios log file : " nagios_log_path
		
		transfert_nagios_command="/usr/bin/rsync -avr --rsh=\"/usr/bin/ssh -p \$2 \" \`/usr/bin/find $nagios_log_path -type f -mtime -2\`  eyesofreport@\$1:/home/eyesofreport/external_depot/Log_Nagios_Depot/"
		cron_command="eyesofreport $source_path/transfert_nagios_log.sh $eor_address $eor_ssh_port "
		#	echo -e "cron command : $cron_command"
	
		nagios_continue=1
		while [ -n "$(cat /etc/crontab | grep -n -m 1 "transfert_nagios_log.sh $eor_address $eor_ssh_port" | awk -F ":" '{print $1}')" ]; 
		do
			myLine=$(cat /etc/crontab | grep -n -m 1 "transfert_nagios_log.sh $eor_address $eor_ssh_port" | awk -F ":" '{print $1}')
			while true; do
				read -p "A nagios log transfert is already scheduled in /etc/crontab for port $eor_ssh_port on eyes of report server $eor_address. Do you want to remove it ? (y/n)" yn
				case $yn in
					[Yy]* ) sed -i -e "$myLine"'d' /etc/crontab;break;;
					[Nn]* ) echo -e "Eyes of Report Source : Nagios log transfert scheduling :	\e[33m[CANCELED] \e[39m";nagios_continue=0;break;;
					* ) echo "Please answer y or n.";;
				esac
			done
		
			if [ $nagios_continue -eq 0 ]; then
				break;
			fi

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
	configure_nagios_bp_source=1
	while true; do
		read -p "2: Nagios bp transfert configuration. Skip this step ? (y/n) " yn
		case $yn in
			[Nn]* ) configure_nagios_bp_source=1;break;;
			[Yy]* ) configure_nagios_bp_source=0;break;;
			* ) echo "Please answer y or n.";;
		esac
	done
	
	if [ $configure_nagios_bp_source -eq 1 ]; then
		read -p "Enter absolute path of nagios bp sql dump file: " nagios_bp_log_path
		
		transfert_nagios_bp_command="/usr/bin/rsync -avr --rsh=\"/usr/bin/ssh -p \$2 \" \`/usr/bin/find $nagios_bp_log_path -type f -mtime -2\`  eyesofreport@\$1:/home/eyesofreport/external_depot/Nagios_BP_Depot/"
		cron_command="eyesofreport $source_path/transfert_nagios_bp.sh $eor_address $eor_ssh_port "
		#	echo -e "cron command : $cron_command"
	
		nagiosbp_continue=1
		while [ -n "$(cat /etc/crontab | grep -n -m 1 "transfert_nagios_bp.sh $eor_address $eor_ssh_port" | awk -F ":" '{print $1}')" ]; 
		do
			myLine=$(cat /etc/crontab | grep -n -m 1 "transfert_nagios_bp.sh $eor_address $eor_ssh_port" | awk -F ":" '{print $1}')
			while true; do
				read -p "A nagios bp transfert is already scheduled in /etc/crontab for port $eor_ssh_port on eyes of report server $eor_address. Do you want to remove it ? (y/n)" yn
				case $yn in
					[Yy]* ) sed -i -e "$myLine"'d' /etc/crontab;break;;
					[Nn]* ) echo -e "Eyes of Report Source : Nagios bp transfert scheduling :	\e[33m[CANCELED] \e[39m";nagiosbp_continue=0;break;;
					* ) echo "Please answer y or n.";;
				esac
			done
		
			if [ $nagiosbp_continue -eq 0 ]; then
				break;
			fi

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
	while true; do
		read -p "3: Ged transfert configuration. Skip this step ? (y/n) " yn
		case $yn in
			[Nn]* ) configure_ged_source=1;break;;
			[Yy]* ) configure_ged_source=0;break;;
			* ) echo "Please answer y or n.";;
		esac
	done
	
	if [ $configure_ged_source -eq 1 ]; then
		read -p "Enter absolute path of ged sql dump file: " nagios_ged_path
		
		transfert_ged_command="/usr/bin/rsync -avr --rsh=\"/usr/bin/ssh -p \$2 \" \`/usr/bin/find $nagios_ged_path -type f -mtime -2\`  eyesofreport@\$1:/home/eyesofreport/external_depot/Ged_Depot/"
		cron_command="eyesofreport $source_path/transfert_ged.sh $eor_address $eor_ssh_port "
		#	echo -e "cron command : $cron_command"
	
		ged_continue=1
		while [ -n "$(cat /etc/crontab | grep -n -m 1 "transfert_ged.sh $eor_address $eor_ssh_port" | awk -F ":" '{print $1}')" ]; 
		do
			myLine=$(cat /etc/crontab | grep -n -m 1 "transfert_ged.sh $eor_address $eor_ssh_port" | awk -F ":" '{print $1}')
			while true; do
				read -p "A GED transfert is already scheduled in /etc/crontab for port $eor_ssh_port on eyes of report server $eor_address. Do you want to remove it ? (y/n)" yn
				case $yn in
					[Yy]* ) sed -i -e "$myLine"'d' /etc/crontab;break;;
					[Nn]* ) echo -e "Eyes of Report Source : Ged transfert scheduling :	\e[33m[CANCELED] \e[39m";ged_continue=0;break;;
					* ) echo "Please answer y or n.";;
				esac
			done
		
			if [ $ged_continue -eq 0 ]; then
				break;
			fi

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
	configure_lilac_source=1
	while true; do
		read -p "4: Lilac transfert configuration. Skip this step ? (y/n)  " yn
		case $yn in
			[Nn]* ) configure_lilac_source=1;break;;
			[Yy]* ) configure_lilac_source=0;break;;
			* ) echo "Please answer y or n.";;
		esac
	done
	
	if [ $configure_lilac_source -eq 1 ]; then
		read -p "Enter absolute path of lilac sql dump file: " nagios_lilac_path
		
		transfert_lilac_command="/usr/bin/rsync -avr --rsh=\"/usr/bin/ssh -p \$2 \" \`/usr/bin/find $nagios_lilac_path -type f -mtime -2\`  eyesofreport@\$1:/home/eyesofreport/external_depot/Lilac_Depot/"
		cron_command="eyesofreport $source_path/transfert_lilac.sh $eor_address $eor_ssh_port "
		#	echo -e "cron command : $cron_command"
	
		lilac_continue=1
		while [ -n "$(cat /etc/crontab | grep -n -m 1 "transfert_lilac.sh $eor_address $eor_ssh_port" | awk -F ":" '{print $1}')" ]; 
		do
			myLine=$(cat /etc/crontab | grep -n -m 1 "transfert_lilac.sh $eor_address $eor_ssh_port" | awk -F ":" '{print $1}')
			while true; do
				read -p "A Lilac transfert is already scheduled in /etc/crontab for port $eor_ssh_port on eyes of report server $eor_address. Do you want to remove it ? (y/n)" yn
				case $yn in
					[Yy]* ) sed -i -e "$myLine"'d' /etc/crontab;break;;
					[Nn]* ) echo -e "Eyes of Report Source : Lilac transfert scheduling :	\e[33m[CANCELED] \e[39m";lilac_continue=0;break;;
					* ) echo "Please answer y or n.";;
				esac
			done
		
			if [ $lilac_continue -eq 0 ]; then
				break;
			fi

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
	

	
	

