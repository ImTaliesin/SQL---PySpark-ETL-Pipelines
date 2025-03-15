# NYC Taxi Data

## Source

The data is sourced from the New York City Taxi and Limousine Commission (TLC).

## ETL Pipleine

The data is cleaned, transformed, and loaded into a relational database using SQL.

## trip data green_csv contans the following columns:
| VendorID | tpep_pickup_datetime | tpep_dropoff_datetime | passenger_count | trip_distance | RatecodeID | store_and_fwd_flag | PULocationID | DOLocationID | payment_type | fare_amount | extra | mta_tax | tip_amount | tolls_amount | improvement_surcharge | total_amount | congestion_surcharge | airport_fee | Stop_Array |

We start with the raw data in CSV format, which is then partitioned by year and month.
