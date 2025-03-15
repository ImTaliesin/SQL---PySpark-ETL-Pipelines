--Transform the csv file to parquet
--Create external table as select (CETAS)

use nyc_taxi_ldw;

if object_id('silver.taxi_zone') is not NULL
    drop external table silver.taxi_zone
go

create external table silver.taxi_zone
    with(
        DATA_SOURCE = nyc_taxi_src,
        LOCATION = 'silver/taxi_zone',
        FILE_FORMAT = parquet_file_format
    )
as 
select * 
    from bronze.taxi_zone

select * from silver.taxi_zone

