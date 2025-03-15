use nyc_taxi_discovery;

--Error with comma in file
SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'vendor_unquoted.csv',
        DATA_SOURCE = 'nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE
    ) AS vendor;

--Added a \ behind the comma to be the 'escape character' for the parser
    SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'vendor_escaped.csv',
        DATA_SOURCE = 'nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE,
        ESCAPE_CHAR ='\\'
    ) AS vendor;


--Added quotes to all lines for the parser
    SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'vendor.csv',
        DATA_SOURCE = 'nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE,
        FIELDQUOTE = '"'

    ) AS vendor;