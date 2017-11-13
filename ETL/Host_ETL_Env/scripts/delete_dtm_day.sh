#!/bin/bash
#########################################
#
# Copyright (C) 2016 EyesOfNetwork Team
# DEV NAME : Benoit Village Jan 2016
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

# this script allows to delete data on one day into dtm tables

if [ "$1" == "" ] || [ "$2" == "" ]; then
    echo "Usage : delete_dtm_day_v2.sh YYYY_MM_DD YYYY_MM_DD"
else
    echo "I delete dtm table between $1 and $2"
fi

user=eyesofreport
password=SaintThomas,2014
database=eor_dwh

echo "DELETE from  f_dtm_application_unavailability_minute WHERE FDB_EPOCH_MINUTE between '$1' and '$2';" | mysql --user="$user" --password="$password" --database="$database" 
echo "DELETE FROM f_dtm_application_unavailability_minute executed"

echo "DELETE from  f_dtm_application_contract_unavailability_minute WHERE acm_epoch_minute between '$1' and '$2';" | mysql --user="$user" --password="$password" --database="$database" 
echo "DELETE FROM f_dtm_application_contract_unavailability_minute executed"

echo "DELETE FROM f_dtm_hs_unavailability_minute WHERE FDU_EPOCH_MINUTE between '$1' and '$2';" | mysql --user="$user" --password="$password" --database="$database" 
echo "DELETE FROM f_dtm_hs_unavailability_minute executed"

echo "DELETE FROM f_dtm_appli_unavailability_hour where AUH_EPOCH_HOUR between UNIX_TIMESTAMP(DATE_FORMAT(FROM_UNIXTIME('$1'),'%Y-%m-%d %H')) and UNIX_TIMESTAMP(DATE_FORMAT(FROM_UNIXTIME('$2'),'%Y-%m-%d %H'));" | mysql --user="$user" --password="$password" --database="$database" 
echo "DELETE FROM f_dtm_appli_unavailability_hour executed"

echo "DELETE FROM f_dtm_hs_unavailability_hour where HUH_EPOCH_HOUR between UNIX_TIMESTAMP(DATE_FORMAT(FROM_UNIXTIME('$1'),'%Y-%m-%d %H')) and UNIX_TIMESTAMP(DATE_FORMAT(FROM_UNIXTIME('$2'),'%Y-%m-%d %H'));" | mysql --user="$user" --password="$password" --database="$database" 
echo "DELETE FROM f_dtm_hs_unavailability_hour executed"

echo "DELETE FROM f_dtm_appli_unavailability_day where AUD_EPOCH_DAY between UNIX_TIMESTAMP(DATE_FORMAT(FROM_UNIXTIME('$1'),'%Y-%m-%d')) and UNIX_TIMESTAMP(DATE_FORMAT(FROM_UNIXTIME('$2'),'%Y-%m-%d'));" | mysql --user="$user" --password="$password" --database="$database" 
echo "DELETE FROM f_dtm_appli_unavailability_day executed"

echo "DELETE FROM f_dtm_hs_unavailability_day where HUD_EPOCH_DAY between UNIX_TIMESTAMP(DATE_FORMAT(FROM_UNIXTIME('$1'),'%Y-%m-%d')) and UNIX_TIMESTAMP(DATE_FORMAT(FROM_UNIXTIME('$2'),'%Y-%m-%d'));" | mysql --user="$user" --password="$password" --database="$database" 
echo "DELETE FROM f_dtm_hs_unavailability_day executed"

echo "DELETE FROM f_dtm_appli_unavailability_month where AUM_EPOCH_MONTH between UNIX_TIMESTAMP(CONCAT(DATE_FORMAT(FROM_UNIXTIME('$1'),'%Y-%m'),'-01')) and UNIX_TIMESTAMP(CONCAT(DATE_FORMAT(FROM_UNIXTIME('$2'),'%Y-%m'),'-01'));" | mysql --user="$user" --password="$password" --database="$database" 
echo "DELETE FROM f_dtm_appli_unavailability_month executed"

echo "DELETE FROM f_dtm_hs_unavailability_month where HUM_EPOCH_MONTH between UNIX_TIMESTAMP(CONCAT(DATE_FORMAT(FROM_UNIXTIME('$1'),'%Y-%m'),'-01')) and UNIX_TIMESTAMP(CONCAT(DATE_FORMAT(FROM_UNIXTIME('$2'),'%Y-%m'),'-01'));" | mysql --user="$user" --password="$password" --database="$database" 
echo "DELETE FROM f_dtm_hs_unavailability_month executed"

echo "DELETE FROM f_dtm_appli_unavailability_month_hour where AUMH_EPOCH_MONTH_HOUR between UNIX_TIMESTAMP(CONCAT(DATE_FORMAT(FROM_UNIXTIME('$1'),'%Y-%m'),'-01')) + DATE_FORMAT(FROM_UNIXTIME('$1'),'%H') and UNIX_TIMESTAMP(CONCAT(DATE_FORMAT(FROM_UNIXTIME('$2'),'%Y-%m'),'-01')) + DATE_FORMAT(FROM_UNIXTIME('$2'),'%H');" | mysql --user="$user" --password="$password" --database="$database" 
echo "DELETE FROM f_dtm_appli_unavailability_month_hour executed"

echo "DELETE FROM f_dtm_hs_unavailability_month_hour where HUMH_EPOCH_MONTH_HOUR between UNIX_TIMESTAMP(CONCAT(DATE_FORMAT(FROM_UNIXTIME('$1'),'%Y-%m'),'-01')) + DATE_FORMAT(FROM_UNIXTIME('$1'),'%H') and UNIX_TIMESTAMP(CONCAT(DATE_FORMAT(FROM_UNIXTIME('$2'),'%Y-%m'),'-01')) + DATE_FORMAT(FROM_UNIXTIME('$2'),'%H');" | mysql --user="$user" --password="$password" --database="$database" 
echo "DELETE FROM f_dtm_hs_unavailability_month_hour executed"

echo "DELETE FROM f_dtm_appli_link_contract_unavail_min WHERE ALM_EPOCH_MINUTE between '$1' and '$2';" | mysql --user="$user" --password="$password" --database="$database" 
echo "DELETE FROM f_dtm_appli_link_contract_unavail_min executed"

echo "DELETE FROM f_dtm_appli_link_contract_unavail_hour where ALH_EPOCH_HOUR between UNIX_TIMESTAMP(DATE_FORMAT(FROM_UNIXTIME('$1'),'%Y-%m-%d %H')) and UNIX_TIMESTAMP(DATE_FORMAT(FROM_UNIXTIME('$2'),'%Y-%m-%d %H'));" | mysql --user="$user" --password="$password" --database="$database" 
echo "DELETE FROM f_dtm_appli_link_contract_unavail_hour executed"

echo "DELETE FROM f_dtm_appli_link_contract_unavail_day where ALD_EPOCH_DAY between UNIX_TIMESTAMP(DATE_FORMAT(FROM_UNIXTIME('$1'),'%Y-%m-%d')) and UNIX_TIMESTAMP(DATE_FORMAT(FROM_UNIXTIME('$2'),'%Y-%m-%d'));" | mysql --user="$user" --password="$password" --database="$database" 
echo "DELETE FROM f_dtm_appli_link_contract_unavail_day executed"

echo "DELETE FROM f_dtm_appli_link_contract_unavail_month where ALM_EPOCH_MONTH between UNIX_TIMESTAMP(CONCAT(DATE_FORMAT(FROM_UNIXTIME('$1'),'%Y-%m'),'-01')) and UNIX_TIMESTAMP(CONCAT(DATE_FORMAT(FROM_UNIXTIME('$2'),'%Y-%m'),'-01'));" | mysql --user="$user" --password="$password" --database="$database" 
echo "DELETE FROM f_dtm_appli_link_contract_unavail_month executed"

echo "DELETE FROM f_dtm_appli_link_ana_contract_unavail_min WHERE AAM_EPOCH_MINUTE between '$1' and '$2';" | mysql --user="$user" --password="$password" --database="$database" 
echo "DELETE FROM f_dtm_appli_link_ana_contract_unavail_min executed"

echo "DELETE FROM f_dtm_appli_link_ana_contract_unavail_hour where AAH_EPOCH_HOUR between UNIX_TIMESTAMP(DATE_FORMAT(FROM_UNIXTIME('$1'),'%Y-%m-%d %H')) and UNIX_TIMESTAMP(DATE_FORMAT(FROM_UNIXTIME('$2'),'%Y-%m-%d %H'));" | mysql --user="$user" --password="$password" --database="$database" 
echo "DELETE FROM f_dtm_appli_link_ana_contract_unavail_hour executed"

echo "DELETE FROM f_dtm_appli_link_ana_contract_unavail_day where AAD_EPOCH_DAY between UNIX_TIMESTAMP(DATE_FORMAT(FROM_UNIXTIME('$1'),'%Y-%m-%d')) and UNIX_TIMESTAMP(DATE_FORMAT(FROM_UNIXTIME('$2'),'%Y-%m-%d'));" | mysql --user="$user" --password="$password" --database="$database" 
echo "DELETE FROM f_dtm_appli_link_ana_contract_unavail_day executed"

echo "DELETE FROM f_dtm_appli_link_ana_contract_unavail_month where AAM_EPOCH_MONTH between UNIX_TIMESTAMP(CONCAT(DATE_FORMAT(FROM_UNIXTIME('$1'),'%Y-%m'),'-01')) and UNIX_TIMESTAMP(CONCAT(DATE_FORMAT(FROM_UNIXTIME('$2'),'%Y-%m'),'-01'));" | mysql --user="$user" --password="$password" --database="$database" 
echo "DELETE FROM f_dtm_appli_link_ana_contract_unavail_month executed"

exit


