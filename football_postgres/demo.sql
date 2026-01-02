SELECT aws_s3.table_import_from_s3(
  'raw_schema.player_market_values',                   -- target table
  '',                                   -- column list ('' = all)
  '(format csv, header true)',          -- options
  'preksha-bucket-1',
  'Football-Dataset/player_market_value.csv',
  'us-east-1'
);

create table raw_schema.player_market_values (
player_id serial ,
date_unix date,
value float
);

drop table raw_schema.player_market_values;
