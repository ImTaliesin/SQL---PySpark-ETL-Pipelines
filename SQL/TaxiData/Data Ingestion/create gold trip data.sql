USE nyc_taxi_ldw;

/*
SELECT TOP 100 
    td.year,
    td.month, 
    tz.borough,
    cal.day_name AS trip_day,
    CASE WHEN cal.day_name IN ('Saturday', 'Sunday') THEN 'Yes' ELSE 'No' END AS trip_day_weekend_ind,
    CONVERT(DATE, td.lpep_pickup_datetime) AS trip_date,
    SUM(CASE WHEN pt.description = 'Credit card' THEN 1 ELSE 0 END) AS card_trip_count,
    SUM(CASE WHEN pt.description = 'Cash' THEN 1 ELSE 0 END) AS cash_trip_count
FROM silver.vw_trip_data_green td
JOIN silver.taxi_zone tz ON td.pu_location_id = tz.location_id
JOIN silver.calendar cal ON cal.date = CONVERT(DATE, td.lpep_pickup_datetime)
JOIN silver.payment_type pt ON td.payment_type = pt.payment_type
WHERE td.year = '2020'
    AND td.month = '01'
GROUP BY td.year,
         td.month,
         tz.borough,
         cal.day_name,
         CONVERT(DATE, td.lpep_pickup_datetime)
ORDER BY td.year, td.month, tz.borough, trip_date;
*/

-- 2020
exec gold.usp_gold_trip_data_green '2020','01'
exec gold.usp_gold_trip_data_green '2020','02'
exec gold.usp_gold_trip_data_green '2020','03'
exec gold.usp_gold_trip_data_green '2020','04'
exec gold.usp_gold_trip_data_green '2020','05'
exec gold.usp_gold_trip_data_green '2020','06'
exec gold.usp_gold_trip_data_green '2020','07'
exec gold.usp_gold_trip_data_green '2020','08'
exec gold.usp_gold_trip_data_green '2020','09'
exec gold.usp_gold_trip_data_green '2020','10'
exec gold.usp_gold_trip_data_green '2020','11'
exec gold.usp_gold_trip_data_green '2020','12'

-- 2021
exec gold.usp_gold_trip_data_green '2021','01'
exec gold.usp_gold_trip_data_green '2021','02'
exec gold.usp_gold_trip_data_green '2021','03'
exec gold.usp_gold_trip_data_green '2021','04'
exec gold.usp_gold_trip_data_green '2021','05'
exec gold.usp_gold_trip_data_green '2021','06'