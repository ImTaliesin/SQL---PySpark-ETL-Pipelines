use nyc_taxi_ldw;
GO

create or alter PROCEDURE silver.usp_silver_taxi_zone
as 
begin
if object_id('silver.taxi_zone') is not NULL
    drop external table silver.taxi_zone

create external table silver.taxi_zone
    with(
        DATA_SOURCE = nyc_taxi_src,
        LOCATION = 'silver/taxi_zone',
        FILE_FORMAT = parquet_file_format
    )
as 
select * 
    from bronze.taxi_zone

end;

