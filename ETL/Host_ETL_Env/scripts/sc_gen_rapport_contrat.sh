#!/bin/bash

SCRIPTNAME="sc_gen_rapport_contrat.sh"
REVISION="0.1"

usage () {
echo "Usage : ${SCRIPTNAME} - Version : ${REVISION}
This script writen to permit report generation automaticaly for daily gen in crontab or
manually to generate global month.

Options :
	-h             Invoke this help
	-M             Force script to manual usage (You could specify -y and -m)
	-y <year>      Specify year for generate contrat report (Format YYYY)
	-m <month>     Specify month for generate contrat report (Format MM)"
exit 3
}

ARGS="$(echo $@ |sed -e 's:-[[:alpha:]] :\n&:g' | sed -e 's: ::g')"
for i in $ARGS; do
        if [ -n "$(echo ${i} | grep "^\-h")" ]; then usage ;fi
        if [ -n "$(echo ${i} | grep "^\-M")" ]; then Mode="manual" ;fi
        if [ -n "$(echo ${i} | grep "^\-y")" ]; then previous_year="$(echo ${i} | cut -c 3-)"; fi
        if [ -n "$(echo ${i} | grep "^\-m")" ]; then previous_month="$(echo ${i} | cut -c 3-)"; fi
done

if [ ! ${Mode} ]
then
	previous_year=$(date --date="$(date +%Y-%m-15)" +'%Y')
	previous_month=$(date --date="$(date +%Y-%m-15)" +'%Y')
	date_month_folder=${previous_year}${previous_month}
	date_month=${previous_year}${previous_month}-01
elif [ ${Mode} == "manual" ]
then
	if [ ! ${previous_year} ];then echo "You've not specify year" ; exit 3 ;fi
	if [ ! ${previous_month} ];then echo "You've not specify month"; exit 3 ;fi
	date_month_folder=${previous_year}${previous_month}
	date_month=${previous_year}${previous_month}-01
else
	echo "Invalid mode"
	exit 3
fi

MYSQL_PWD=root66
month_folder=/var/archive/eyesofreport/Contract_Monthly/${date_month_folder}

mkdir -p $month_folder

current_datetime=$(date +"%Y-%m-%d %r")
echo $current_datetime "Creation du dossier /var/archive/eyesofreport/Contract_Monthly/"$date_month " OK" >> $month_folder/creation_rapports.log

application_list=$(MYSQL_PWD=$MYSQL_PWD mysql -uroot -e "SELECT distinct dcc_name from d_contract_context" eor_dwh)

MYSQL_PWD=$MYSQL_PWD mysql -uroot -e "SELECT distinct dcc_name from d_contract_context" eor_dwh | tail -n +2 > $month_folder/liste_contrats.txt

nb_contrats=$(cat ${month_folder}/liste_contrats.txt | wc -l)
for i in $(seq 1 ${nb_contrats})
do

	line_contrat="$(cat ${month_folder}/liste_contrats.txt | head -${i} | tail -1)"
    contrat=$line_contrat
	contrat_id=$(MYSQL_PWD=$MYSQL_PWD mysql -uroot -e "SELECT dcc_id from d_contract_context where dcc_name='$contrat'" eor_dwh | tail -n +2)
	contrat=$(echo $line_contrat|sed -e 's/ /_/g' -e 's/\//-/g')
	continue=1
	month_application_folder=$month_folder/$contrat
	mkdir -p $month_application_folder
	cd $month_application_folder
	
	if [ $continue -eq 1 ]; then
		report_name=${date_month_folder}_${contrat}.pptx
		rm -f ${date_month_folder}_${contrat}.pptx
		contrat=$line_contrat
		echo $(date +"%Y-%m-%d %r") "Generation rapport $contrat pour le $previous_year-$previous_month" >> $month_folder/creation_rapports.log
		wget -q -O $report_name "http://localhost:8080/birt/run?__report=EOR_Contract_Application_FR.rptdesign&__format=PPTX&Year=$previous_year&__isdisplay__Year=$previous_year&Month=$previous_month&__isdisplay__Month=$previous_month&contract_context=$contrat" >> /dev/null
	fi
done

cd $month_folder

rm -f $month_folder/creation_rapports.log
rm -f $month_folder/liste_contrats.txt

