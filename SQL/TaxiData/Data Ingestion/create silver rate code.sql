use nyc_taxi_ldw

if object_id('silver.rate_code') is not NULL
DROP EXTERNAL TABLE silver.rate_code
GO

create external table silver.rate_code
    with(
        DATA_SOURCE = nyc_taxi_src,
        LOCATION = 'silver/rate_code',
        FILE_FORMAT = parquet_file_format
    )
as 
select * 
    from 
    OPENROWSET(
        bulk 'raw/rate_code.json',
        data_source = 'nyc_taxi_src',
        format = 'csv',
        FIELDQUOTE = '0x0b',
        FIELDTERMINATOR = '0x0b',
        ROWTERMINATOR = '0x0b'
    ) with(
        jsonDoc NVARCHAR(max)
    ) as rate_code
    cross apply OPENJSON(jsonDoc)
    with(
        rate_code_id tinyint,
        rate_code varchar(20)
    )
 

select * from silver.rate_code
