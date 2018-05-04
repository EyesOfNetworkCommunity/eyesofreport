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


cd /srv/eyesofreport/etl/validator/
zip ./ETL_DTM_COMPUTE_STATE_JAR.jar ./AppliAvailabilityCompute.properties

export LANG=en_US
JAVA_Validator="/srv/eyesofreport/etl/validator/ETL_DTM_COMPUTE_STATE_JAR.jar"

usage() {
echo "Usage :application_aggregation.sh epochbegin epochend"
exit
}

LOGDIR="/var/log/eyesofreport/application_aggregator"

if [ ! -d "$LOGDIR" ]; then
	mkdir -p $LOGDIR
fi

epochbeg="$1"
epochnext=$( MYSQL_PWD=root66 mysql -uroot  -e "select unix_timestamp(date_format(from_unixtime($epochbeg+93600),'%Y-%m-%d 00:00:00')) as madate;" | tail -1)
epochend="$2"

executedate=$(date +"%s")
echo "Validator v2 begin execution: $executedate"

echo $(MYSQL_PWD=root66 mysql -uroot  -e "select from_unixtime($epochbeg) as datedeb, from_unixtime($epochnext) as dateend;" | tail -1)

while (true); do
	
	file=${LOGDIR}/etl_ginette_${executedate}.log
	touch $file 
	epochnext_2=`expr "$epochnext" - 1`
	
	/srv/eyesofreport/java/bin/java -Xmx8128m -XX:+UseConcMarkSweepGC -jar $JAVA_Validator "$epochbeg" "$epochnext_2" > $file
	executedatetransite=$(date +"%s")
	diff=`expr "$executedatetransite" - "$executedate"`
	
	executedate=$(date +"%s")
	echo "$(($diff / 60)) minutes and $(($diff % 60)) seconds elapsed for begin : $epochbeg and end : $epochnext."
	
	epochbeg=$epochnext
	epochnext=$(MYSQL_PWD=root66 mysql -uroot -e "select unix_timestamp(date_format(from_unixtime($epochbeg+93600),'%Y-%m-%d 00:00:00')) as madate;" | tail -1)

	if [ $epochbeg -ge $epochend ]; then
			end=$(date +"%s")
			echo "Validator v2 end execution: $end"
			break;
	fi
	
	echo $(MYSQL_PWD=root66 mysql -uroot  -e "select from_unixtime($epochbeg) as datedeb, from_unixtime($epochnext) as dateend;" | tail -1)

	
done

