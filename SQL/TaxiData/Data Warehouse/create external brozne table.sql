use nyc_taxi_ldw;

--check for duplicates in data
CREATE EXTERNAL TABLE bronze.taxi_zone(
    location_id SMALLINT,
    borough VARCHAR(50),
    zone VARCHAR(100),
    service_zone VARCHAR(50)
) WITH (
    LOCATION = 'raw/taxi_zone.csv',
    DATA_SOURCE = nyc_taxi_src,
    FILE_FORMAT = csv_file_format
)

select top 100 * from bronze.taxi_zone

drop external table bronze.taxi_zone