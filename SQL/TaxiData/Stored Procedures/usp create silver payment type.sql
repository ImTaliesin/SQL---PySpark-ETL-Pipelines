use nyc_taxi_ldw;
GO

create or alter PROCEDURE silver.usp_silver_payment_type
as 
begin
if object_id('silver.payment_type') is not NULL
    drop external table silver.payment_type

create external table silver.payment_type
    with(
        DATA_SOURCE = nyc_taxi_src,
        LOCATION = 'silver/payment_type',
        FILE_FORMAT = parquet_file_format
    )
as 
select payment_type, description
from OPENROWSET(
    BULK 'raw/payment_type.json',
    data_source = 'nyc_taxi_src',
    format = 'CSV',
    fieldterminator = '0x0b',
    fieldquote = '0x0b'
) WITH (
    jsonDoc NVARCHAR(MAX)
) as payment_type
CROSS APPLY OPENJSON(jsonDoc)
WITH (
    payment_type smallint,
    description varchar(20) '$.payment_type_desc'
)

end;

