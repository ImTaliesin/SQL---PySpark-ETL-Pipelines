use nyc_taxi_ldw;
GO

create or alter PROCEDURE silver.usp_silver_trip_type
as 
begin
if object_id('silver.trip_type') is not NULL
    drop external table silver.trip_type

create external table silver.trip_type
    with(
        DATA_SOURCE = nyc_taxi_src,
        LOCATION = 'silver/trip_type',
        FILE_FORMAT = parquet_file_format
    )
as 
select * 
    from bronze.trip_type

end;

