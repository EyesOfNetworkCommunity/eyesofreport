#!/bin/bash
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

#if [ -z "$1" ]; then
# echo "Usage script_generation_rapport.sh year month"
# exit 1
#fi

#if [ -z "$2" ]; then
# echo "Usage script_generation_rapport.sh year month"
# exit 1
#fi


MYSQL_PWD=root66
#param_year=$1
#param_month=$2
previous_year=$(date --date="$(date +%Y-%m-15) -1 month" +'%Y')
previous_month=$(date --date="$(date +%Y-%m-15) -1 month" +'%m')
date_month_folder=${previous_year}${previous_month}
#date_month_folder=$(date -d "${param_year}-${param_month}-01" '+%Y%m')
date_month=${previous_year}-${previous_month}-01
#date_month=$(date -d "${param_year}-${param_month}-01" '+%Y-%m-%d')
month_folder=/var/archive/eor_rapports_mensuels/${date_month_folder}

rm -rf /var/archive/eor_rapports_mensuels/${date_month_folder}

mkdir -p $month_folder

current_datetime=$(date +"%Y-%m-%d %r")
echo $current_datetime "Création du dossier /var/archive/eor_rapports_mensuels/"$date_month " OK" >> $month_folder/creation_rapports.log

application_list=$(MYSQL_PWD=$MYSQL_PWD mysql -uroot -e "SELECT distinct dap_name from d_application where dap_priority=1" eor_dwh)

MYSQL_PWD=$MYSQL_PWD mysql -uroot -e "SELECT distinct dap_name from d_application where dap_priority=1" eor_dwh | tail -n +2 > $month_folder/liste_application.txt

#Get contract id for contract "Full"
contract_context_id=$(MYSQL_PWD=$MYSQL_PWD mysql -uroot -e "SELECT dcc_id from d_contract_context where dcc_name = 'Full'" eor_dwh | tail -n +2)

while read application
do 
	application_id=$(MYSQL_PWD=$MYSQL_PWD mysql -uroot -e "SELECT dap_id from d_application where dap_name='$application'" eor_dwh | tail -n +2)
	application_level=$(MYSQL_PWD=$MYSQL_PWD mysql -uroot -e "SELECT dap_priority from d_application where dap_name='$application'" eor_dwh | tail -n +2)
	
	continue=1
	contract_context_id_custom="0"
	contract_context_name_custom="0"
	month_application_folder=$month_folder/$application
	mkdir -p $month_application_folder
	cd $month_application_folder
   
	#get if application is linked to contract 'Complet'
	nb_record=$(MYSQL_PWD=$MYSQL_PWD mysql -uroot -e "select count(dap_name) from d_contract_context_application inner join d_application on dap_id=dca_appli_id where dap_name='$application' and dca_dcc_id=$contract_context_id" eor_dwh | tail -n +2)
	if [ $nb_record -eq 1 ]; then
		echo $(date +"%Y-%m-%d %r") "L'application $application est bien liée au contexte de contrat Full" >> $month_folder/creation_rapports.log
		contract_context_id_custom=$contract_context_id
		contract_context_name_custom="Full"
	else 
		echo $(date +"%Y-%m-%d %r") "L'application $application n'est pas liée au contexte de contrat Full" >> $month_folder/creation_rapports.log
		contract_context_id_custom=$(MYSQL_PWD=$MYSQL_PWD mysql -uroot -e "select dca_dcc_id from d_contract_context_application inner join d_application on dap_id=dca_appli_id where dap_name='$application' limit 1" eor_dwh | tail -n +2)
		contract_context_name_custom=$(MYSQL_PWD=$MYSQL_PWD mysql -uroot -e "select dcc_name from d_contract_context_application inner join d_application on dap_id=dca_appli_id inner join d_contract_context on dcc_id = dca_dcc_id where dap_name='$application' limit 1" eor_dwh | tail -n +2)
		if [ -z "$contract_context_id_custom" ]; then
			continue=0
			echo $(date +"%Y-%m-%d %r") "L'application $application n'est liée a aucun contexte de contrat" >> $month_folder/creation_rapports.log
		else 
			echo $(date +"%Y-%m-%d %r") "Le contexte de contrat $contract_context_name_custom sera utilisé pour l'application $application" >> $month_folder/creation_rapports.log
		fi
	fi
	
	if [ $continue -eq 1 ]; then
		MYSQL_PWD=$MYSQL_PWD mysql -uroot -e "select distinct aud_date from (SELECT aud_date,aud_contract_context_id,  sum(aud_unavailability_down) from f_dtm_appli_unavailability_day where aud_appli=$application_id and date_format(aud_date,'%Y-%m-01')='$date_month' and aud_contract_context_id=$contract_context_id_custom group by aud_date, aud_contract_context_id having sum(aud_unavailability_down) > 0 order by aud_date)a;" eor_dwh | tail -n +2 > $month_application_folder/liste_date.txt
		#echo "SELECT distinct aud_date from f_dtm_appli_unavailability_day where aud_appli=$application_id and date_format(aud_date,'%Y-%m-01')=$date_month"
		while read date
		do
			current_day=$(date -d "$date" '+%d')
			current_month=$(date -d "$date" '+%m')
			current_year=$(date -d "$date" '+%Y')
			report_name=${date_month_folder}${current_day}_${application}_analyse_incident.pdf
			echo $(date +"%Y-%m-%d %r") "Génération rapport $application ($contract_context_name_custom) pour le ${current_year}-${current_month}-${current_day}" >> $month_folder/creation_rapports.log
			wget -q -O $report_name "http://localhost:8080/birt/run?__report=EOR_Application_incident_analysis_FR.rptdesign&__format=PDF&Year=${current_year}&__isdisplay__Year=${current_year}&Month=${current_month}&__isdisplay__Month=${current_month}&Day=${current_day}&__isdisplay__Day=${current_day}&Niveau=${application_level}&__isdisplay__Niveau=${application_level}&Application=${application_id}&__isdisplay__Application=${application}&Contract_contxt=${contract_context_id_custom}&__isdisplay__Contract_contxt=${contract_context_name_custom}" >> /dev/null
		done < $month_application_folder/liste_date.txt
	fi
done < $month_folder/liste_application.txt

cd $month_folder