use nyc_taxi_ldw;


if not exists (select * from sys.external_file_formats where name = 'csv_file_format')
create external file format csv_file_format
with (
    format_type = DELIMITEDTEXT,
    format_options (
        field_terminator = ',' ,
        string_delimiter = '"',
        first_row = 2 ,
        use_type_default = FALSE,
        Encoding = 'UTF8',
        PARSER_VERSION = '2.0' 
    )

);

if not exists (select * from sys.external_file_formats where name = 'csv_file_format_pv1')
create external file format csv_file_format_pv1
with (
    format_type = DELIMITEDTEXT,
    format_options (
        field_terminator = ',' ,
        string_delimiter = '"',
        first_row = 2 ,
        use_type_default = FALSE,
        Encoding = 'UTF8',
        PARSER_VERSION = '1.0' 
    )

);

-- Create extenal file format for parquet
if not exists (select * from sys.external_file_formats where name = 'parquet_file_format')
    create external file format parquet_file_format
    with (
        FORMAT_TYPE = PARQUET,
        DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'
    )