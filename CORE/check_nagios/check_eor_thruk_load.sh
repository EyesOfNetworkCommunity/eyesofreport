#!/bin/sh
#------------------------------------------------------------------------------
#
#   PROJECT      :  EyesOfNetwork EyesOfReport load project
#
#   AUTOR        :  Benoit Village - Axians
#
#   DATE         :  Octobre 2016
#
#   HELP         :  see "usage"
#
#   COMMENT      : this plugin test if log nagios has been successfully logged in thruk database. 
#
#------------------------------------------------------------------------------
export LANG="fr_FR.UTF-8"

usage ()
{
  nom=`basename $0`
  echo ""
  echo "Usage : $nom -H <hostname> -B <backend>"
  echo " "
  echo "     -H <hostname>"
  echo "     -B <backend thruk>"
  echo "     -N <number of records expected>"
  echo " "
  echo "Example : $nom -H server_eor -B 4452b"
  echo " "
exit 1
}

# Check arguments
while getopts ":B:H:N:" OPTS
do
    case $OPTS in
        B) BACKEND=$OPTARG ;;
        H) HOST=$OPTARG ;;
	N) NBREC=$OPTARG ;;
        *) usage ;;
    esac
done

#if [ "${8}" = "" ]; then usage; fi

#HOST='10.99.2.119'
#BACKEND='4452b'

extractbeg=$(date --date="$(date +%Y-%m-%d --date="yesterday")"  +%s)
extractend=$(($(date --date="$(date +%Y-%m-%d --date="yesterday")"  +%s) + 86399))
extractdate=$(date +%Y-%m-%d --date="yesterday")

#extractbeg=1466546400
#extractend=1466632799	

time_day_record=$(MYSQL_PWD="xxxxxxxx" mysql -sN -ueyesofreport -h $HOST -e "SELECT count(*) FROM thruk.${BACKEND}_log where time between $extractbeg and $extractend limit 1;")

#echo "$time_day_record"
#echo "$NBREC"

if [ "$time_day_record" -lt "$NBREC" ]; then
	echo "CRITICAL: number of log record for date $extractdate is less than expected : expected ($NBREC) measured ($time_day_record) "
	exit 2
fi


echo "OK: log nagios has been loaded in thruk database for date $extractdate  : $time_day_record log records stored"
exit 0



