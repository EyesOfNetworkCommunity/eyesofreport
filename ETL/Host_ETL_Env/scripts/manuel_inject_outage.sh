#!/bin/bash

# Michael Aubertin Nov 2014
# Benoit Village Jan 2016

export LANG=en_US

usage() {
echo "Usage :manuel_inject_outage_V6.sh
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
#EPOCHEND="`expr $EPOCHEND + 1`"
CURRENT_EPOCH="`date +%s`"


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
# DIFFTime="`expr $EPOCHEND - $EPOCHSTART`"
# if [ $DIFFTime -lt 300 ]; then
# 	echo ""
# 	echo ""
# 	echo "The time scope couldn't be less than 5 minutes."
# 	echo ""
# 	echo ""
# 	usage
# fi

if [ ! -d /tmp/raw_add ]; then mkdir -p /tmp/raw_add; fi
TMPDIR="`mktemp -d /tmp/raw_add/Add_thruk_raw.XXXXXXXX`"

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

if [ ! "${BACKEND}" = "Solarwind" ]; then
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
		if [ "$SERVICE" = "Hoststatus" ]; then
			echo -n ""
		else 	
			#echo "SELECT service_id from ${BACKEND}_service where host_id='${host_id}' AND service_description='${SERVICE}';"
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
	fi
fi

TimeToHandle=$EPOCHSTART
MAX_Message_id_DOWN="`echo "SELECT max(output_id) + 1 from ${BACKEND}_plugin_output;" | mysql -u${USER} -p${PASSWD} thruk | grep -v "max"`"
MAX_Message_id_UP="`expr $MAX_Message_id_DOWN + 1`"
#echo "insert into ${BACKEND}_plugin_output VALUES ($MAX_Message_id_DOWN,'CRITICAL;HARD;2;$CURRENT_EPOCH');" | mysql -u${USER} -p${PASSWD} thruk 2> /dev/null
#echo "insert into ${BACKEND}_plugin_output VALUES ($MAX_Message_id_UP,'UP;HARD;1;$CURRENT_EPOCH');" | mysql -u${USER} -p${PASSWD} thruk 2> /dev/null
#echo "insert into ${BACKEND}_plugin_output VALUES ($MAX_Message_id_DOWN,'CRITICAL;HARD;2;$CURRENT_EPOCH');" 
#echo "insert into ${BACKEND}_plugin_output VALUES ($MAX_Message_id_UP,'UP;HARD;1;$CURRENT_EPOCH');" 
Mysql_Return="`echo $?`"
if [ $Mysql_Return -gt 0 ]; then
   echo ""
   echo ""
   echo "Cannot add message to database."
   echo ""
   echo ""
	 rm -rf $TMPDIR
	 exit
fi


if [ ! "${BACKEND}" = "Solarwind" ]; then
   echo -n "Adding outage for "
   if [ "$TYPE" = "Host" ]; then
	  echo -n "host $HOST "
      echo "insert into ${BACKEND}_log VALUES ($EPOCHSTART,1,'HOST ALERT',1,'HARD',NULL,$host_id,NULL,1,$MAX_Message_id_DOWN);" | mysql -u${USER} -p${PASSWD} thruk 2> /dev/null
      EPOCHLOOP="$EPOCHSTART"
      TimeRange="`expr $EPOCHEND - $EPOCHSTART`"
      LOOP="`expr $TimeRange / 60`"
      LOOP="`expr $LOOP + 1`" 
      while ([ $LOOP -gt 0 ]); do 
      	echo "insert into ${BACKEND}_log VALUES ($EPOCHLOOP,1,'HOST ALERT',1,'HARD',NULL,$host_id,NULL,1,$MAX_Message_id_DOWN);" | mysql -u${USER} -p${PASSWD} thruk 2> /dev/null
      	EPOCHLOOP="`expr $EPOCHLOOP + 60`"
      	LOOP="`expr $LOOP - 1`"
      	echo -n "."
      done
      echo "insert into ${BACKEND}_log VALUES ($EPOCHEND,1,'HOST ALERT',0,'HARD',NULL,$host_id,NULL,1,$MAX_Message_id_UP);" | mysql -u${USER} -p${PASSWD} thruk 2> /dev/null
      #echo "insert into ${BACKEND}_log VALUES ($EPOCHSTART,1,'HOST ALERT',1,'HARD',NULL,$host_id,NULL,1,$MAX_Message_id_DOWN);" 
      #echo "insert into ${BACKEND}_log VALUES ($EPOCHEND,1,'HOST ALERT',0,'HARD',NULL,$host_id,NULL,1,$MAX_Message_id_UP);" 
 
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
      echo "from `date -d @${EPOCHSTART}` to `date -d @${EPOCHEND}` .......[OK]"
   fi	
    if [ "$TYPE" = "Service" ]; then
   
	 if [ "$SERVICE" = "Hoststatus" ]; then
		 echo -n "host $HOST "
		 echo "delete from ${BACKEND}_log where time between $EPOCHSTART and $EPOCHEND and host_id = $host_id and service_id is null and state_type is not null;" | mysql -u${USER} -p${PASSWD} thruk 2> /dev/null
		 echo "insert into ${BACKEND}_log VALUES ($EPOCHSTART,1,'HOST ALERT',2,'HARD',NULL,$host_id,null,1,$MAX_Message_id_DOWN);" | mysql -u${USER} -p${PASSWD} thruk 2> /dev/null
		 echo "insert into ${BACKEND}_log VALUES ($EPOCHEND,1,'HOST ALERT',0,'HARD',NULL,$host_id,null,1,$MAX_Message_id_UP);" | mysql -u${USER} -p${PASSWD} thruk 2> /dev/null
	 else
		 echo -n "service $SERVICE on host $HOST "
		 echo "delete from ${BACKEND}_log where time between $EPOCHSTART and $EPOCHEND and host_id = $host_id and service_id = $service_id and state_type is not null;" | mysql -u${USER} -p${PASSWD} thruk 2> /dev/null
		 echo "insert into ${BACKEND}_log VALUES ($EPOCHSTART,1,'SERVICE ALERT',2,'HARD',NULL,$host_id,$service_id,1,$MAX_Message_id_DOWN);" | mysql -u${USER} -p${PASSWD} thruk 2> /dev/null
		 echo "insert into ${BACKEND}_log VALUES ($EPOCHEND,1,'SERVICE ALERT',0,'HARD',NULL,$host_id,$service_id,1,$MAX_Message_id_UP);" | mysql -u${USER} -p${PASSWD} thruk 2> /dev/null
	 fi
     echo "from `date -d @${EPOCHSTART}` to `date -d @${EPOCHEND}` .......[OK]"
	
	fi
fi


# if [ "${BACKEND}" = "Solarwind" ]; then
	# if [ -f ./keycopter-network-chain-availability.csv ]; then
		# # Verif Asset exist.
		# IsPresent="`cat ./keycopter-network-chain-availability.csv | grep "^${NAME},"`"
		# if [ -n "${IsPresent}" ]; then
			# TimeToHandle=$EPOCHSTART
			# while(true); do
				# if [ $TimeToHandle -gt $EPOCHEND ]; then
					# break
				# fi
				# CurrentDate="`date "+%d/%m/%Y %H:%M:%S" -d @$TimeToHandle`"
				# NAMEWrite="`echo "${NAME}" | sed -e 's:\\\::g'`"
				# echo -n "Adding outage for ${NAMEWrite} "
				# Done="0"
				# if [ -n "`cat ./keycopter-network-chain-availability.csv | grep "^${NAME},$CurrentDate,0"`" ] ;then
					# echo ".... Skipping, outage already exist at $CurrentDate."
					# Done="1"
				# fi
				# if [ -n "`cat ./keycopter-network-chain-availability.csv | grep "^${NAME},$CurrentDate,100"`" ] ;then
					# TimePlusOne="`expr $TimeToHandle + 1`"
					# OldTime="`date "+%d/%m/%Y %H:%M:%S" -d @$TimeToHandle`"
					# CurrentDate="`date "+%d/%m/%Y %H:%M:%S" -d @$TimePlusOne`"
					# echo -n "already ok at $OldTime! " 
						# if [ -n "`cat ./keycopter-network-chain-availability.csv | grep "^${NAME},$CurrentDate,0"`" ] ;then
							# echo ".... Skipping, outage already exist at $CurrentDate."
						# else
							# echo "${NAMEWrite},$CurrentDate,0" >> ./keycopter-network-chain-availability.csv
							# echo "Adding outage at ${CurrentDate}.......[OK]"
						# fi
					# Done="1"
				# fi
				# if [ "$Done" -eq "0" ]; then 
					# echo "${NAMEWrite},$CurrentDate,0" >> ./keycopter-network-chain-availability.csv
					# echo "at $CurrentDate .......[OK]"
				# fi
				# TimeToHandle="`expr $TimeToHandle + 155`" # 5 second is to get Validar Java class job more easy :)
			# done
		# fi
	# else
		# echo ""
		# echo ""
		# echo "File keycopter-network-chain-availability.csv, must be present in this directory."
		# echo ""
		# echo ""
		# rm -rf $TMPDIR
		# exit
	# fi
# fi

#ls -l /tmp/raw_add
#echo "Start: $EPOCHSTART"
#echo "Stop: $EPOCHEND"
#echo "Diff: $DIFFTime"
#echo "Host:$HOST"
#echo "Service:$SERVICE"
#echo "host_id=$host_id"
#echo "service_id=$service_id"



rm -rf $TMPDIR
exit 0