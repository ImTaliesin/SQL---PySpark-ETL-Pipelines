use nyc_taxi_discovery;

select * 
    from OPENROWSET(
        BULK 'payment_type.json',
        data_source = 'nyc_taxi_data_raw',
        format = 'CSV',

        FIELDTERMINATOR = '0x0b',
        FIELDQUOTE = '0x0b'
    )
    WITH (
        jsonDoc NVARCHAR(MAX)
    ) AS payment_type
    CROSS APPLY OPENJSON(jsonDoc)
    WITH (
        payment_type smallint,
        payment_type_desc varchar(20)
    )


--Read json data w/ arrays
select payment_type, payment_type_desc_value
from OPENROWSET(
    BULK 'payment_type_array.json',
    data_source = 'nyc_taxi_data_raw',
    format = 'CSV',
    PARSER_VERSION = '1.0',
    FIELDTERMINATOR = '0x0b',
    FIELDQUOTE = '0x0b',
    ROWTERMINATOR = '0x0a'
)
WITH (
    jsonDoc NVARCHAR(MAX)
) AS payment_type
CROSS APPLY OPENJSON (jsonDoc)
WITH(
    payment_type SMALLINT,
    payment_type_desc NVARCHAR(MAX) AS JSON
)
CROSS APPLY OPENJSON(payment_type_desc)
WITH(
    sub_type smallint,
    payment_type_desc_value VARCHAR(20) '$.value'
)
