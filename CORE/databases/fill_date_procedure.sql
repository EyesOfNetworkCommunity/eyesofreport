DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `fill_date_dimension`(IN startdate DATETIME,IN stopdate DATETIME)
BEGIN
    DECLARE currentdate DATETIME;
    SET currentdate = startdate;
    WHILE currentdate < stopdate DO
        INSERT INTO d_time_dimension VALUES (
                        UNIX_TIMESTAMP(DATE_FORMAT(currentdate,'%Y-%m-%d %H:%i')),
                        UNIX_TIMESTAMP(DATE_FORMAT(currentdate,'%Y-%m-%d %H')),
						UNIX_TIMESTAMP(DATE_FORMAT(currentdate,'%Y-%m-%d')),
                        UNIX_TIMESTAMP(CONCAT(DATE_FORMAT(currentdate,'%Y-%m'),'-01')),
                        UNIX_TIMESTAMP(CONCAT(DATE_FORMAT(currentdate,'%Y'),'-01-01')),
                        UNIX_TIMESTAMP(CONCAT(DATE_FORMAT(currentdate,'%Y-%m'),'-01')) + DATE_FORMAT(currentdate,'%H'),
                        DATE_FORMAT(currentdate,'%Y-%m-%d %H:%i:%s'),
                        DATE_FORMAT(currentdate,'%Y-%m-%d'),
                        YEAR(currentdate),
                        DATE_FORMAT(currentdate,'%m'),
                        DATE_FORMAT(currentdate,'%d'),
                        DAY(LAST_DAY(currentdate)),
                        QUARTER(currentdate),
                        DATE_FORMAT(currentdate,'%H'),
                        DATE_FORMAT(currentdate,'%i'),
                        DATE_FORMAT(currentdate,'%H')*60 + DATE_FORMAT(currentdate,'%i'),
                        DATE_FORMAT(currentdate,'%D'),
                        DATE_FORMAT(currentdate,'%M'),
                        CASE DAYOFWEEK(currentdate) WHEN 1 THEN 't' WHEN 7 then 't' ELSE 'f' END,
                        unix_timestamp(date_add(from_unixtime(UNIX_TIMESTAMP(DATE_FORMAT(currentdate,'%Y-%m-%d %H'))), interval 1 hour)) - UNIX_TIMESTAMP(DATE_FORMAT(currentdate,'%Y-%m-%d %H')),
                        unix_timestamp(date_add(from_unixtime(UNIX_TIMESTAMP(DATE_FORMAT(currentdate,'%Y-%m-%d'))), interval 1 day)) - UNIX_TIMESTAMP(DATE_FORMAT(currentdate,'%Y-%m-%d')),
                        unix_timestamp(date_add(from_unixtime(UNIX_TIMESTAMP(CONCAT(DATE_FORMAT(currentdate,'%Y-%m'),'-01'))), interval 1 month)) - UNIX_TIMESTAMP(CONCAT(DATE_FORMAT(currentdate,'%Y-%m'),'-01')) 
                        );
        SET currentdate = ADDDATE(currentdate,INTERVAL 1 MINUTE);
    END WHILE;
END;;
DELIMITER ;
