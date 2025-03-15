use nyc_taxi_discovery;

SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'calendar.csv',
        DATA_SOURCE = 'nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE
    ) WITH (
        date_key        int,
        date            date,
        year            smallint,
        month           tinyint,
        day             tinyint,
        day_name        varchar(10),
        day_of_year     smallint,
        week_of_month   TINYINT,
        week_of_year    TINYINT,
        month_name      VARCHAR(10),
        year_month      INT,
        year_week       INT
    ) AS calendar;

    exec sp_describe_first_result_set N'SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK ''calendar.csv'',
        DATA_SOURCE = ''nyc_taxi_data_raw'',
        FORMAT = ''CSV'',
        PARSER_VERSION = ''2.0'',
        HEADER_ROW = TRUE
    )  AS calendar '
 
exec sp_describe_first_result_set N'
 SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK ''calendar.csv'',
        DATA_SOURCE = ''nyc_taxi_data_raw'',
        FORMAT = ''CSV'',
        PARSER_VERSION = ''2.0'',
        HEADER_ROW = TRUE
    ) WITH (
        date_key        int,
        date            date,
        year            smallint,
        month           tinyint,
        day             tinyint,
        day_name        varchar(10),
        day_of_year     smallint,
        week_of_month   TINYINT,
        week_of_year    TINYINT,
        month_name      VARCHAR(10),
        year_month      INT,
        year_week       INT
    ) AS calendar ;'

