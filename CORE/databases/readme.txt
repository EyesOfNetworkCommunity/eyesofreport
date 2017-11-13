mysql -uroot -p eor_dwh < /tmp/fill_date_procedure.sql
mysql -uroot -p eor_dwh
DROP INDEX idx_d_time_dimension_hour on d_time_dimension;
DROP INDEX idx_d_time_dimension_day on d_time_dimension;
DROP INDEX idx_d_time_dimension_month on d_time_dimension;
DROP INDEX idx_d_time_dimension_month_hour on d_time_dimension;
DROP INDEX td_dbdate_idx on d_time_dimension;
DROP INDEX idx_d_time_dimension_year on d_time_dimension;
DROP INDEX idx_d_time_dimension_month_num on d_time_dimension;

CALL fill_date_dimension('2017-01-01 00:01:00','2020-01-01 00:00:00');

CREATE INDEX idx_d_time_dimension_hour on d_time_dimension(epoch_hour) using btree;
CREATE INDEX idx_d_time_dimension_day on d_time_dimension(epoch_day) using btree;
CREATE INDEX idx_d_time_dimension_month on d_time_dimension(epoch_month) using btree;
CREATE INDEX idx_d_time_dimension_month_hour on d_time_dimension(epoch_month_hour) using btree;
CREATE INDEX td_dbdate_idx on d_time_dimension(db_datetime) using btree;
CREATE INDEX idx_d_time_dimension_year on d_time_dimension(year) using btree;
CREATE INDEX idx_d_time_dimension_month_num on d_time_dimension(month) using btree;

