use nyc_taxi_discovery

SELECT
    borough,
    count(1) as number_of_records
FROM
    OPENROWSET(
        BULK 'https://synapsecoursedatalakes.dfs.core.windows.net/nyc-taxi-data/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        HEADER_ROW = TRUE,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        PARSER_VERSION = '2.0'
    ) AS [result] 
    group by borough
    having count (1) > 1


--two unknown boroughs?
SELECT *
FROM
    OPENROWSET(
        BULK 'https://synapsecoursedatalakes.dfs.core.windows.net/nyc-taxi-data/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        HEADER_ROW = TRUE,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        PARSER_VERSION = '2.0'
    ) AS [result] 
WHERE borough = 'Unknown'

--Data Quality checks
SELECT 
    MIN(total_amount) as min_total_amount,
    MAX(total_amount) as max_total_amount,
    AVG(total_amount) as avg_total_amount,
    count(1) as total_records,
    count(total_amount) as not_null_total_amount_of_records
FROM
    OPENROWSET(
        BULK 'trip_data_green_parquet/year=2020/month=01/',
        data_source = 'nyc_taxi_data_raw',
        FORMAT = 'PARQUET'
    ) AS [result] 

--Figure out how many payment types exist, why the data looks weird 
SELECT 
    payment_type, count(1) as number_of_records
FROM
    OPENROWSET(
        BULK 'trip_data_green_parquet/year=2020/month=01/',
        data_source = 'nyc_taxi_data_raw',
        FORMAT = 'PARQUET'
    ) AS [result]
    where total_amount < 0
    GROUP by payment_type
    order by payment_type
