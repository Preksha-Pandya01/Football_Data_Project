create table raw_schema.transfer_history(
player_id integer,
season_name text,
transfer_date date,
from_team_id integer,
from_team_name text,
to_team_id integer,
to_team_name text,
transfer_type text,
value_at_transfer integer,
transfer_fee integer
);

SELECT aws_s3.table_import_from_s3(
  'raw_schema.transfer_history',                   -- target table
  '',                                   -- column list ('' = all)
  '(format csv, header true)',          -- options
  'preksha-bucket-1',
  'Football-Dataset/transfer_history.csv',
  'us-east-1'
);

select * from raw_schema.transfer_history;
