use nyc_taxi_ldw

if object_id('bronze.calendar') is not NULL
    DROP EXTERNAL TABLE bronze.calendar

create external table  bronze.calendar
(
    date_key    INT,
    date        DATE,
    year        SMALLINT,
    month       TINYINT,
    day         TINYINT,
    day_name    VARCHAR(10),
    day_of_year SMALLINT,
    week_of_month TINYINT,
    week_of_year TINYINT,
    month_name VARCHAR(10),
    year_month int,
    year_week int
) WITH(
    location = 'raw/calendar.csv',
    data_source = nyc_taxi_src,
    FILE_FORMAT = csv_file_format_pv1,
    reject_value = 10,
    rejected_row_location = 'rejections/calendar'
);

select * from bronze.calendar