create table raw_schema.player_injuries(
player_id serial,
season_name text,
injury_reason text,
from_date date,
end_date date,
days_missed float,
games_missed integer
);

SELECT aws_s3.table_import_from_s3(
  'raw_schema.player_injuries',                   -- target table
  '',                                   -- column list ('' = all)
  '(format csv, header true)',          -- options
  'preksha-bucket-1',
  'Football-Dataset/player_injuries.csv',
  'us-east-1'
);

select * from raw_schema.player_injuries;