create table raw_schema.team_competitions_seasons(
club_id integer,
team_name text,
season_id text,
competition_name text,
competition_id text,
club_division text,
_last_modified_at timestamp
);


SELECT aws_s3.table_import_from_s3(
  'raw_schema.team_competitions_seasons',                   -- target table
  '',                                   -- column list ('' = all)
  '(format csv, header true)',          -- options
  'preksha-bucket-1',
  'Football-Dataset/team_competitions_seasons.csv',
  'us-east-1'
);

select * from raw_schema.team_competitions_seasons;

