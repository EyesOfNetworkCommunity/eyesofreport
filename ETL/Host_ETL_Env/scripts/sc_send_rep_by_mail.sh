#!/bin/bash
#########################################
#
# Copyright (C) 2016 EyesOfNetwork Team
# DEV NAME : Benoit Village Dec 2017
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
# Updated and merged scripts by Vincent FRICOU <vincent@fricouv.eu>
# Date : Feb 19, 2018
#
#########################################

SCRIPTNAME="sc_send_rep_by_mail.sh"
REVISION="0.1"

usage () {
echo "Usage : ${SCRIPTNAME} - Version : ${REVISION}
This script writen to automaticaly export reports and send them by email.

In automatic mode, the script will send previous month.
This designed to could send reports from previous month in date of 1st of current month.

Options :
	-h             Invoke this help
	-M             Force script to manual usage (You could specify -y and -m)
	-y <year>      Specify year for report you'll send (Format YYYY)
	-m <month>     Specify month for report you'll send (Format MM)"
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
	previous_year=$(date "+%Y")
	previous_month=$(date --date="-1 month" +'%m')
	if [ ${previous_month} == 12 ]
	then
		previous_year=$(expr ${previous_year} - 1)
	fi
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

cd /srv/eyesofreport/etl/scripts/
yearmonth=${previous_year}${previous_month}
wget "http://cluster:root66@localhost:8181/kettle/runJob/?job=/Alimentation/5_TECHNIQUE/ENVOI_MAIL_RAPPORT&yearmonth=$yearmonth" > /dev/null
yes | rm /srv/eyesofreport/etl/scripts/index*
