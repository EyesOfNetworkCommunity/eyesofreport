#!/bin/bash

#########################################
#
# Copyright (C) 2016 EyesOfNetwork Team
# DEV NAME : # Michael Aubertin Nov 2014 & Benoit Village Jan 2016
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

export LANG=en_US

usage() {
echo "Usage :manuel_inject_downtime_V2.sh
	login
	Password
	Type [Host or Service]
	Backend Thruk accronym (ex: f6dd1) or Solarwind
	Start Date of outage (YYYY_MM_DD_hh:mm)
	End Date of outage (YYYY_MM_DD_hh:mm)
	Name (host or host.service)% Take care about '%' the separate host name and service name"
exit
}

if [ "${7}" = "" ]; then usage; fi

USER="`echo ${1}`"; if [ ! -n "${USER}" ]; then usage;fi
PASSWD="`echo ${2}`"; if [ ! -n "${PASSWD}" ]; then usage;fi
TYPE="`echo ${3}`"; if [ ! -n "${TYPE}" ]; then usage;fi
BACKEND="`echo ${4}`"; if [ ! -n "${BACKEND}" ]; then usage;fi
STARTD="`echo ${5}`"; if [ ! -n "${STARTD}" ]; then usage;fi
ENDD="`echo ${6}`"; if [ ! -n "${ENDD}" ]; then usage;fi
NAME="`echo ${7}`"; if [ ! -n "${NAME}" ]; then usage;fi

if [ ! "$TYPE" = "Host" ]; then 
	if [ ! "$TYPE" = "Service" ]; then 
		echo ""
		echo ""
		echo "Error: Type must be Host or Service"
		echo ""
		echo ""
		usage
	fi
fi

SYEAR="`echo $STARTD | cut -d'_' -f1`"
EYEAR="`echo $ENDD | cut -d'_' -f1`"
SMONTH="`echo $STARTD | cut -d'_' -f2`"
EMONTH="`echo $ENDD | cut -d'_' -f2`"
SDAY="`echo $STARTD | cut -d'_' -f3`"
EDAY="`echo $ENDD | cut -d'_' -f3`"
SHOUR="`echo $STARTD | cut -d'_' -f4 | cut -d':' -f1`"
EHOUR="`echo $ENDD | cut -d'_' -f4 | cut -d':' -f1`"
SMINUTE="`echo $STARTD | cut -d'_' -f4 | cut -d':' -f2`"
EMINUTE="`echo $ENDD | cut -d'_' -f4 | cut -d':' -f2`"
EPOCHSTART="`date -d "${SYEAR}${SMONTH}${SDAY} ${SHOUR}${SMINUTE}" +%s 2> /dev/null`"
EPOCHEND="`date -d "${EYEAR}${EMONTH}${EDAY} ${EHOUR}${EMINUTE}" +%s 2> /dev/null`"
EPOCHSTART="`expr $EPOCHSTART + 5`"
EPOCHEND="`expr $EPOCHEND - 5`"


if [ ! -n "$EPOCHSTART" ]; then
	echo ""
	echo ""
	echo "Invalid start date or format."
	echo ""
	echo ""
	usage
fi
if [ ! -n "$EPOCHEND" ]; then
	echo ""
	echo ""
	echo "Invalid end date or format."
	echo ""
	echo ""
	usage
fi
DIFFTime="`expr $EPOCHEND - $EPOCHSTART`"
if [ $DIFFTime -lt 300 ]; then
	echo ""
	echo ""
	echo "The time scope couldn't be less than 5 minutes."
	echo ""
	echo ""
	usage
fi

if [ ! -d /tmp/raw_add ]; then mkdir -p /tmp/raw_add; fi
TMPDIR="`mktemp -d /tmp/raw_add/Add_thruk_raw_downtime.XXXXXXXX`"

if [ "$TYPE" = "Host" ]; then 
	HOST=$NAME
	if [ -n "`echo "${HOST}" | grep "%"`" ]; then
		echo ""
		echo ""
		echo "Character % is not allowed in Hostname."
		echo ""
		echo ""
		rm -rf $TMPDIR
		usage
	fi
fi
if [ "$TYPE" = "Service" ]; then 
	HOST="`echo $NAME | cut -d"%" -f1`"
	SERVICE="`echo $NAME | cut -d"%" -f2 | sed -e 's/:/ /g'`"
	if [ ! -n "${SERVICE}" ]; then
		echo ""
		echo ""
		echo "Service name unspecified or malformed"
		echo ""
		echo ""
		rm -rf $TMPDIR
		usage
	fi
fi

if [ ! -n "$HOST" ]; then
	echo ""
	echo ""
	echo "Host name unspecified or malformed"
	echo ""
	echo ""
	rm -rf $TMPDIR
	usage
fi

ConnEstab="`echo "SHOW STATUS" | mysql -u${USER} -p${PASSWD} thruk`"
if [ ! -n "${ConnEstab}" ]; then
	echo ""
	echo ""
	echo "Connection to MySQL db not possible with specified credantials."
	echo ""
	echo ""
	rm -rf $TMPDIR
	usage
fi


host_id="`echo "SELECT host_id from ${BACKEND}_host where host_name='${HOST}';" | mysql -u${USER} -p${PASSWD} thruk | grep -v "host_id"`"

if [ ! -n "${host_id}" ]; then
	echo ""
	echo ""
	echo "Host ${HOST} not found in ${BACKEND} backend."
	echo ""
	echo ""
	rm -rf $TMPDIR
	usage
fi

if [ "$TYPE" = "Service" ]; then
	echo "SELECT service_id from ${BACKEND}_service where host_id='${host_id}' AND service_description='${SERVICE}';"
	service_id="`echo "SELECT service_id from ${BACKEND}_service where host_id='${host_id}' AND service_description='${SERVICE}';" | mysql -u${USER} -p${PASSWD} thruk | grep -v "service_id"`"
	if [ ! -n "${service_id}" ]; then
		echo ""
		echo ""
		echo "Service ${SERVICE} on Host ${HOST} not found in ${BACKEND} backend."
		echo ""
		echo ""
		rm -rf $TMPDIR
		usage
	fi
fi

MAX_Message_id="`echo "SELECT max(output_id) + 1 from ${BACKEND}_plugin_output;" | mysql -u${USER} -p${PASSWD} thruk | grep -v "max"`"
MAX_Message_id_stop="`expr $MAX_Message_id + 1`"
echo -n "Adding downtime for "
if [ "$TYPE" = "Host" ]; then
	echo -n "host $HOST "
	echo "insert into ${BACKEND}_plugin_output VALUES ($MAX_Message_id,'STARTED; Host has entered a corrected period of scheduled downtime');" | mysql -u${USER} -p${PASSWD} thruk 2> /dev/null
	echo "insert into ${BACKEND}_plugin_output VALUES ($MAX_Message_id_stop,'STOPPED; Host has exited a corrected period of scheduled downtime');" | mysql -u${USER} -p${PASSWD} thruk 2> /dev/null

echo "insert into ${BACKEND}_log VALUES ($EPOCHSTART,1,'HOST DOWNTIME ALERT',NULL,'',NULL,$host_id,NULL,1,$MAX_Message_id);" | mysql -u${USER} -p${PASSWD} thruk 2> /dev/null
EPOCHLOOP="$EPOCHSTART"
TimeRange="`expr $EPOCHEND - $EPOCHSTART`"
LOOP="`expr $TimeRange / 60`"
LOOP="`expr $LOOP + 1`" 
while ([ $LOOP -gt 0 ]); do 
	echo "insert into ${BACKEND}_log VALUES ($EPOCHLOOP,1,'HOST DOWNTIME ALERT',NULL,'',NULL,$host_id,NULL,1,$MAX_Message_id);" | mysql -u${USER} -p${PASSWD} thruk 2> /dev/null
	EPOCHLOOP="`expr $EPOCHLOOP + 60`"
	LOOP="`expr $LOOP - 1`"
	echo -n "."
done

echo "insert into ${BACKEND}_log VALUES ($EPOCHEND,1,'HOST DOWNTIME ALERT',NULL,'',NULL,$host_id,NULL,1,$MAX_Message_id_stop);" | mysql -u${USER} -p${PASSWD} thruk 2> /dev/null
 
	Mysql_Return="`echo $?`"
	if [ $Mysql_Return -gt 0 ]; then
			echo ""
			echo ""
			echo "last mysql resquest of insertion return an error."
			echo ""
			echo ""
			rm -rf $TMPDIR
			exit
	fi
	echo "at $CurrentDate .......[OK]"
fi
if [ "$TYPE" = "Service" ]; then
	echo -n "service $SERVICE on host $HOST "
	echo "insert into ${BACKEND}_plugin_output VALUES ($MAX_Message_id,'STARTED; Service has entered a corrected period of scheduled downtime');" | mysql -u${USER} -p${PASSWD} thruk 2> /dev/null
	echo "insert into ${BACKEND}_plugin_output VALUES ($MAX_Message_id_stop,'STOPPED; Service has exited a corrected period of scheduled downtime');" | mysql -u${USER} -p${PASSWD} thruk 2> /dev/null

echo "insert into ${BACKEND}_log VALUES ($EPOCHSTART,1,'SERVICE DOWNTIME ALERT',NULL,'',NULL,$host_id,$service_id,1,$MAX_Message_id);" | mysql -u${USER} -p${PASSWD} thruk 2> /dev/null
EPOCHLOOP="$EPOCHSTART"
TimeRange="`expr $EPOCHEND - $EPOCHSTART`"
LOOP="`expr $TimeRange / 60`"
LOOP="`expr $LOOP + 1`" 
while ([ $LOOP -gt 0 ]); do 
	echo "insert into ${BACKEND}_log VALUES ($EPOCHLOOP,1,'SERVICE DOWNTIME ALERT',NULL,'',NULL,$host_id,$service_id,1,$MAX_Message_id_stop);" | mysql -u${USER} -p${PASSWD} thruk 2> /dev/null
	EPOCHLOOP="`expr $EPOCHLOOP + 60`"
	LOOP="`expr $LOOP - 1`"
	echo -n "."
done
echo "insert into ${BACKEND}_log VALUES ($EPOCHEND,1,'SERVICE DOWNTIME ALERT',NULL,'',NULL,$host_id,$service_id,1,$MAX_Message_id_stop);" | mysql -u${USER} -p${PASSWD} thruk 2> /dev/null

 	#echo "insert into ${BACKEND}_log VALUES ($EPOCHSTART,1,'SERVICE DOWNTIME ALERT',NULL,'',NULL,$host_id,$service_id,1,$MAX_Message_id);"
	#echo "insert into ${BACKEND}_log VALUES ($EPOCHEND,1,'SERVICE DOWNTIME ALERT',NULL,'',NULL,$host_id,$service_id,1,$MAX_Message_id_stop);"
 
	Mysql_Return="`echo $?`"
	if [ $Mysql_Return -gt 0 ]; then
			echo ""
			echo ""
			echo "last mysql resquest of insertion return an error."
			echo ""
			echo ""
			rm -rf $TMPDIR
			exit
	fi
	echo "at $CurrentDate .......[OK]"
fi

rm -rf $TMPDIR
exit 0
