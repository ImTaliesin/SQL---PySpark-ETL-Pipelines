use nyc_taxi_discovery;

--identify trip data
select top 100 *
from OPENROWSET(
    BULK 'trip_data_green_parquet/year=2020/month=01/',
    data_source = 'nyc_taxi_data_raw',
    format = 'parquet'
) as [result]
where PULocationID IS NULL
--none are null

--Join data
select taxi_zone.borough, count(1) as number_of_trips
from OPENROWSET(
    BULK 'trip_data_green_parquet/year=2020/month=01/',
    data_source = 'nyc_taxi_data_raw',
    format = 'parquet'
) as trip_data
join OPENROWSET(
    BULK 'taxi_zone.csv',
    data_source = 'nyc_taxi_data_raw',
    format = 'csv',
    firstrow = 2
) with (
    location_id smallint 1,
    borough varchar(15) 2,
    zone varchar(50) 3,
    service_zone varchar(15) 4
) as taxi_zone
on trip_data.PULocationID = taxi_zone.location_id
group by taxi_zone.borough
order by number_of_trips DESC
