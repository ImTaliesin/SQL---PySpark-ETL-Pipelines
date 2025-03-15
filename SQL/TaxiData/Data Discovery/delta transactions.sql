use nyc_taxi_discovery;

--Using delta files, must specify the main folder because of the delta log folder.
select top 100 tip_amount, trip_type
from openrowset(
    bulk 'trip_data_green_delta/',
    data_source = 'nyc_taxi_data_raw',
    format= 'delta'
) 
as trip_data;

--Specicy partions with where clause.
select top 100 tip_amount, trip_type
from openrowset(
    bulk 'trip_data_green_delta/',
    data_source = 'nyc_taxi_data_raw',
    format= 'delta'
) with(
    tip_amount float,
    trip_type int,
    year varchar(4),
    month varchar(2)
)
as trip_data
where year = '2020' and month='01';
