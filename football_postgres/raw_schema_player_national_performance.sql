create table raw_schema.player_national_performance(
player_id integer,
team_id text,
team_name text,
first_game_date date,
matches integer,
goals integer
);

drop table raw_schema.player_national_performance;

SELECT aws_s3.table_import_from_s3(
  'raw_schema.player_national_performance',                   -- target table
  '',                                   -- column list ('' = all)
  '(format csv, header true)',          -- options
  'preksha-bucket-1',
  'Football-Dataset/player_national_performances.csv',
  'us-east-1'
);

select * from raw_schema.player_national_performance;