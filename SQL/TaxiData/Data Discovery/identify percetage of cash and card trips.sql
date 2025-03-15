use nyc_taxi_discovery;
--Delta files
/*
{"payment_type":1,"payment_type_desc":"Credit card"} 
{"payment_type":2,"payment_type_desc":"Cash"} 
{"payment_type":3,"payment_type_desc":"No charge"} 
{"payment_type":4,"payment_type_desc":"Dispute"} 
{"payment_type":5,"payment_type_desc":"Unknown"} 
{"payment_type":6,"payment_type_desc":"Voided trip"}
*/
select top 100 *
from openrowset(
    bulk 'trip_data_green_delta/',
    data_source = 'nyc_taxi_data_raw',
    format= 'delta'
)
as trip_data
where year = '2020';

--CSV files
select * from
    OPENROWSET(
        BULK 'https://synapsecoursedatalakes.dfs.core.windows.net/nyc-taxi-data/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        HEADER_ROW = TRUE,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        PARSER_VERSION = '2.0'
    ) AS taxi_zone

--Join
SELECT 
    taxi_zone.Borough,
    COUNT(1) AS total_trips,
    SUM(CASE WHEN trip_data.payment_type = 2 THEN 1 ELSE 0 END) AS cash_trips,
    SUM(CASE WHEN trip_data.payment_type = 1 THEN 1 ELSE 0 END) AS card_trips,
    CAST(100.0 * SUM(CASE WHEN trip_data.payment_type = 2 THEN 1 ELSE 0 END) / COUNT(1) AS DECIMAL(5,2)) AS cash_trips_percentage,
    CAST(100.0 * SUM(CASE WHEN trip_data.payment_type = 1 THEN 1 ELSE 0 END) / COUNT(1) AS DECIMAL(5,2)) AS card_trips_percentage
FROM --Main data
    OPENROWSET(
        BULK 'trip_data_green_delta/',
        DATA_SOURCE = 'nyc_taxi_data_raw',
        FORMAT = 'DELTA'
    ) AS trip_data
JOIN --fact table
    OPENROWSET(
        BULK 'taxi_zone.csv',
        DATA_SOURCE = 'nyc_taxi_data_raw',
        FORMAT = 'CSV',
        HEADER_ROW = TRUE,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        PARSER_VERSION = '2.0'
    ) AS taxi_zone
ON 
    trip_data.PULocationID = taxi_zone.LocationID
WHERE 
    trip_data.year = '2020'
GROUP BY 
    taxi_zone.Borough
ORDER BY 
    total_trips DESC

