use nyc_taxi_ldw

if object_id('silver.vendor') is not NULL
DROP EXTERNAL TABLE silver.vendor
GO

create external table silver.vendor
    with(
        DATA_SOURCE = nyc_taxi_src,
        LOCATION = 'silver/vendor',
        FILE_FORMAT = parquet_file_format
    )
as 
select * 
    from bronze.vendor

select * from silver.vendor
