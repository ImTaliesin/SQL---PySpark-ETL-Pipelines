USE nyc_taxi_ldw
GO

CREATE OR ALTER PROCEDURE gold.usp_gold_trip_data_green
    @year VARCHAR(4),
    @month VARCHAR(2)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @create_sql_statement NVARCHAR(MAX),
            @drop_sql_statement NVARCHAR(MAX),
            @table_name NVARCHAR(100),
            @error_message NVARCHAR(1000);

    SET @table_name = 'gold.trip_data_green_' + @year + '_' + @month;

    -- Check if the table exists and drop it if it does
    IF EXISTS (SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID(@table_name))
    BEGIN
        SET @drop_sql_statement = 'DROP EXTERNAL TABLE ' + @table_name;
        EXEC sp_executesql @drop_sql_statement;
        
        -- Verify that the table was dropped
        IF EXISTS (SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID(@table_name))
        BEGIN
            SET @error_message = 'Failed to drop existing table: ' + @table_name;
            THROW 51000, @error_message, 1;
            RETURN;
        END
    END

    -- Create the external table
    SET @create_sql_statement = 'CREATE EXTERNAL TABLE ' + @table_name + ' WITH (
        DATA_SOURCE = nyc_taxi_src,
        LOCATION = ''gold/trip_data_green/year=' + @year + '/month=' + @month + ''',
        FILE_FORMAT = parquet_file_format
    ) AS
    SELECT 
        td.year,
        td.month, 
        tz.borough,
        cal.day_name AS trip_day,
        CASE WHEN cal.day_name IN (''Saturday'', ''Sunday'') THEN ''Yes'' ELSE ''No'' END AS trip_day_weekend_ind,
        CONVERT(DATE, td.lpep_pickup_datetime) AS trip_date,
        COUNT(CASE WHEN pt.description = ''Credit card'' THEN 1 END) AS card_trip_count,
        COUNT(CASE WHEN pt.description = ''Cash'' THEN 1 END) AS cash_trip_count,
        COUNT(CASE WHEN tt.trip_type = 1 THEN 1 END) AS street_hail_trip_count,
        COUNT(CASE WHEN tt.trip_type = 2 THEN 1 END) AS dispatch_trip_count,
        ROUND(SUM(CAST(DATEDIFF(MINUTE, td.lpep_pickup_datetime, td.lpep_dropoff_datetime) AS FLOAT)) / 60, 2) AS trip_duration_hours,
        ROUND(SUM(td.trip_distance), 2) AS trip_distance,
        ROUND(SUM(td.fare_amount), 2) AS fare_amount
    FROM silver.vw_trip_data_green td
    JOIN silver.taxi_zone tz ON td.pu_location_id = tz.location_id
    JOIN silver.calendar cal ON cal.date = CONVERT(DATE, td.lpep_pickup_datetime)
    JOIN silver.payment_type pt ON td.payment_type = pt.payment_type
    JOIN silver.trip_type tt ON td.trip_type = tt.trip_type
    WHERE td.year = ''' + @year + '''
        AND td.month = ''' + @month + '''
    GROUP BY 
        td.year,
        td.month,
        tz.borough,
        cal.day_name,
        CONVERT(DATE, td.lpep_pickup_datetime)';

    EXEC sp_executesql @create_sql_statement;

    -- Uncomment the following lines if you want to drop the external table after creation
    -- SET @drop_sql_statement = 'DROP EXTERNAL TABLE ' + @table_name;
    -- EXEC sp_executesql @drop_sql_statement;
END