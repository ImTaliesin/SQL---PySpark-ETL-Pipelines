use nyc_taxi_ldw;
GO

create or alter PROCEDURE silver.usp_silver_calendar
as 
begin
if object_id('silver.calendar') is not NULL
    drop external table silver.calendar

create external table silver.calendar
    with(
        DATA_SOURCE = nyc_taxi_src,
        LOCATION = 'silver/calendar',
        FILE_FORMAT = parquet_file_format
    )
as 
select * 
    from bronze.calendar

end;

