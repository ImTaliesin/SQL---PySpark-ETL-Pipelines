use nyc_taxi_ldw;

if not exists (select * from sys.external_data_sources where name = 'nyc_taxi_src')
create external data source nyc_taxi_src
WITH(
    location = 'https://synapsecoursedatalakes.dfs.core.windows.net/nyc-taxi-data'
);
