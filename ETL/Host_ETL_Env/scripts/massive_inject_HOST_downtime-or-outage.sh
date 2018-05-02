#!/bin/bash

# Michael Aubertin Nov 2014
# Benoit Village Jan 2016

export LANG=en_US
DataDir="/srv/eyesofreport/etl/injection/"
SetOutageScript="/srv/eyesofreport/etl/scripts/manuel_inject_outage.sh"
SetDowntimeScript="/srv/eyesofreport/etl/scripts/manuel_inject_downtime.sh"


usage() {
echo "Usage :massive_injecti_HOST_downtime-or-outage.sh
	-l login
	-p Password
	-B Backend Thruk accronym (ex: f6dd1) or Solarwind
	-T Type [Downtime or Outage]
	-F CSV input file.

Reminder: The CSV file MUST look like:
Valid;Date debut;Heure debut;Date fin;Heure fin;Type;Host
O;10/10/2014;11:00;10/10/2014;11:15;Incident;arizona
O;23/10/2014;17:15;23/10/2014;19:30;Incident;f5-security-prod:f5-security-prod_failover

Host separator must be the : sign


****** PLEASE USE ONLY ENGLISH Letter not french, German or Unix signs in the file *****"

exit
}

if [ "${5}" = "" ]; then usage; fi




	USER="`echo ${1}`"; if [ ! -n ${USER} ]; then usage;fi
	PASSWD="`echo ${2}`" ; if [ ! -n ${PASSWD} ]; then usage;fi
	BACKEND="`echo ${3}`" ; if [ ! -n ${BACKEND} ]; then usage;fi
	TYPE="`echo ${4} | tr '[:lower:]' '[:upper:]'`"; if [ ! -n ${TYPE} ]; then usage;fi
	FILEIN="`echo ${5}`"; if [ ! -n ${FILEIN} ]; then usage;fi


if [ ! "$TYPE" = "DOWNTIME" ]; then 
	if [ ! "$TYPE" = "OUTAGE" ]; then 
		echo ""
		echo ""
		echo "Error: Type must be DOWNTIME or OUTAGE"
		echo ""
		echo ""
		usage
	fi
fi

if [ ! -f ${DataDir}/${FILEIN} ]; then
		echo ""
		echo ""
		echo "Error: Impossible to find the file ${DataDir}/${FILEIN}"
		echo ""
		echo ""
		usage
fi

if [ ! -x $SetDowntimeScript ]; then
		echo ""
		echo ""
		echo "Error: Impossible to find the command ${SetDowntimeScript}. Sure you are on Vanilla4EON server? :P"
		echo ""
		echo ""
		usage
fi

if [ ! -x $SetOutageScript ]; then
		echo ""
		echo ""
		echo "Error: Impossible to find the command ${SetOutageScript}. Sure you are on Vanilla4EON server? :P"
		echo ""
		echo ""
		usage
fi
if [ ! -x /usr/bin/dos2unix ]; then
		echo ""
		echo ""
		echo "Error: Impossible to find the command dos2unix. Sure you are on Vanilla4EON server? :P"
		echo ""
		echo ""
		usage
fi

dos2unix ${DataDir}/${FILEIN} 2> /dev/null

if [ ! "`head -1 ${DataDir}/${FILEIN}`" == "Valid;Date debut;Heure debut;Date fin;Heure fin;Type;Host;Service" ]; then
		echo ""
		echo ""
		echo "Error: Input file is not in expected format."
		echo ""
		echo ""
		usage
fi

for FileLine in `cat ${DataDir}/${FILEIN} | grep -v "Valid;Date debut;Heure debut;Date fin;Heure fin;Type;Host;Service" | sed -e 's: :%:g' | sed -e 's:\[:\\\[:g' | sed -e 's:\]:\\\]:g'` ; do
	echo $FileLine | sed -e 's:%: :g'
	#O;22/10/2014;07:00;22/10/2014;07:30;Maintenance;arizona

	SYEAR="`echo $FileLine | cut -d';' -f2 | cut -d'/' -f3`"
	EYEAR="`echo $FileLine | cut -d';' -f4 | cut -d'/' -f3`"
	SMONTH="`echo $FileLine | cut -d';' -f2 | cut -d'/' -f2`"
	EMONTH="`echo $FileLine | cut -d';' -f4 | cut -d'/' -f2`"
	SDAY="`echo $FileLine | cut -d';' -f2 | cut -d'/' -f1`"
	EDAY="`echo $FileLine | cut -d';' -f4 | cut -d'/' -f1`"

	SHOUR="`echo $FileLine | cut -d';' -f3 | cut -d':' -f1`"
	EHOUR="`echo $FileLine | cut -d';' -f5 | cut -d':' -f1`"

	SMINUTE="`echo $FileLine | cut -d';' -f3 | cut -d':' -f2`"
	EMINUTE="`echo $FileLine | cut -d';' -f5 | cut -d':' -f2`"

	EPOCHSTART="`date -d "${SYEAR}${SMONTH}${SDAY} ${SHOUR}${SMINUTE}" +%s 2> /dev/null`"
	EPOCHEND="`date -d "${EYEAR}${EMONTH}${EDAY} ${EHOUR}${EMINUTE}" +%s 2> /dev/null`"
	EPOCHSTART="`expr $EPOCHSTART + 5`"
	EPOCHEND="`expr $EPOCHEND + 5`"

	Action="`echo $FileLine | cut -d';' -f6 | tr '[:lower:]' '[:upper:]'`"
	echo "$Action"
	if [ "$TYPE" = "DOWNTIME" ]; then
			if [ ! "$Action" = "MAINTENANCE" ]; then
				if [ ! "$Action" = "DOWNTIME" ]; then
					echo "Skipping line ${FileLine} because the type of action ($Action) doesn't matche the required ($TYPE)."
					continue
				fi
			fi
	fi
	if [ "$TYPE" = "OUTAGE" ]; then
		if [ ! "$Action" = "INCIDENT" ]; then
				if [ ! "$Action" = "OUTAGE" ]; then
					echo "INC: Skipping line ${FileLine} because the type of action ($Action) doesn't matche the required ($TYPE)."
					continue
				fi
			fi	
	fi

	Equipment="`echo $FileLine | cut -d';' -f7`"
	Service="`echo $FileLine | cut -d';' -f8`"
	
	

	if [ "$TYPE" = "DOWNTIME" ]; then
		echo "Adding Downtime for $Equipment from ${SYEAR}/${SMONTH}/${SDAY} ${SHOUR}:${SMINUTE} to ${EYEAR}/${EMONTH}/${EDAY} ${EHOUR}:${EMINUTE}"
		${SetDowntimeScript} ${USER} ${PASSWD} Service ${BACKEND} ${SYEAR}_${SMONTH}_${SDAY}_${SHOUR}:${SMINUTE} ${EYEAR}_${EMONTH}_${EDAY}_${EHOUR}:${EMINUTE} $Equipment%$Service
	fi
	if [ "$TYPE" = "OUTAGE" ]; then
		echo "Adding Outage for $Equipment from ${SYEAR}/${SMONTH}/${SDAY} ${SHOUR}:${SMINUTE} to ${EYEAR}/${EMONTH}/${EDAY} ${EHOUR}:${EMINUTE}"
	    ${SetOutageScript} ${USER} ${PASSWD} Service ${BACKEND} ${SYEAR}_${SMONTH}_${SDAY}_${SHOUR}:${SMINUTE} ${EYEAR}_${EMONTH}_${EDAY}_${EHOUR}:${EMINUTE} $Equipment%$Service
	fi

done



rm -rf $TMPDIR
exit 0
