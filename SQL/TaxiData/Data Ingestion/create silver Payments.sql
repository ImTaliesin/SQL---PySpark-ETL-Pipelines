use nyc_taxi_ldw

if object_id('silver.payment_type') is not NULL
DROP EXTERNAL TABLE silver.payment_type
GO

create external table silver.payment_type
    with(
        DATA_SOURCE = nyc_taxi_src,
        LOCATION = 'silver/payment_type',
        FILE_FORMAT = parquet_file_format
    )
as 
select payment_type, description
    from 
    OPENROWSET(
        bulk 'raw/payment_type.json',
        data_source = 'nyc_taxi_src',
        format = 'csv',
        FIELDQUOTE = '0x0b',
        FIELDTERMINATOR = '0x0b'
    ) with(
        jsonDoc NVARCHAR(max)
    ) as payment_type
    cross apply OPENJSON(jsonDoc)
    with(
        payment_type smallint,
        description varchar(20) '$.payment_type_desc'
    )
 

select * from silver.payment_type
