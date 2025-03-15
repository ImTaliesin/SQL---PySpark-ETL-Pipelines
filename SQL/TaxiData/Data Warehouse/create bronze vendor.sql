use nyc_taxi_ldw

if object_id('bronze.vendor') is not NULL
    DROP EXTERNAL TABLE bronze.vendor

create external table  bronze.vendor
(
    vendor_id tinyint,
    vendor_name varchar(50)
) WITH(
    location = 'raw/vendor.csv',
    data_source = nyc_taxi_src,
    FILE_FORMAT = csv_file_format_pv1,
    reject_value = 10,
    rejected_row_location = 'rejections/vendor'
);

select * from bronze.vendor