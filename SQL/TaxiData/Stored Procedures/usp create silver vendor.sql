use nyc_taxi_ldw;
GO

create or alter PROCEDURE silver.usp_silver_vendor
as 
begin
if object_id('silver.vendor') is not NULL
    drop external table silver.vendor

create external table silver.vendor
    with(
        DATA_SOURCE = nyc_taxi_src,
        LOCATION = 'silver/vendor',
        FILE_FORMAT = parquet_file_format
    )
as 
select * 
    from bronze.vendor

end;

