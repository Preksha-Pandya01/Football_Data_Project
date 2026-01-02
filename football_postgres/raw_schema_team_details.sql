create table raw_schema.team_details(
club_id serial primary key,
club_slug text,
club_name text,
logo_url text,
country_name text,
season_id text,
competition_id text,
competition_slug text,
competition_name text,
club_division text,
source_url text,
_last_modified_at timestamp
);

SELECT aws_s3.table_import_from_s3(
  'raw_schema.team_details',                   -- target table
  '',                                   -- column list ('' = all)
  '(format csv, header true)',          -- options
  'preksha-bucket-1',
  'Football-Dataset/team_details.csv',
  'us-east-1'
);

select * from raw_schema.team_details;