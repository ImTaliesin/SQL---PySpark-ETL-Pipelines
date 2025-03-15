use master
GO

create database nyc_taxi_ldw
GO

alter database nyc_taxi_ldw collate Latin1_General_100_BIN2_UTF8
GO

use nyc_taxi_ldw
GO

create schema bronze
GO

create schema silver
GO

create schema gold
GO
