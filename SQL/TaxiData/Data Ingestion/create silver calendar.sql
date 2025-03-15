use nyc_taxi_ldw

if object_id('silver.calendar') is not NULL
DROP EXTERNAL TABLE silver.calendar
GO

create external table silver.calendar
    with(
        DATA_SOURCE = nyc_taxi_src,
        LOCATION = 'silver/calendar',
        FILE_FORMAT = parquet_file_format
    )
as 
select * 
    from bronze.calendar

select * from silver.calendar
