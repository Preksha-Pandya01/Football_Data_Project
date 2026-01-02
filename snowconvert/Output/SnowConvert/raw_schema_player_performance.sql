create table raw_schema.player_performance (
player_id integer,
season_id text,
competition_id text,
competition_name text,
team_id integer,
team_name text,
nb_in_group integer,
nb_on_pitch integer,
goals float,
assists integer,
own_goals integer,
subed_in integer,
subed_out integer,
yellow_cards integer,
second_yellow_cards integer,
direct_red_cards integer,
penalty_goals integer,
minutes_played float,
goals_conceded integer,
clean_sheets integer
)
COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 17,  "patch": "6.0" }, "attributes": {  "component": "postgresql",  "convertedOn": "09-18-2025",  "domain": "inferenz" }}';
--** SSC-FDM-0007 - MISSING DEPENDENT OBJECT "aws_s3.table_import_from_s3" **
SELECT aws_s3.table_import_from_s3(
  'raw_schema.player_performance',                   -- target table
  '',                                   -- column list ('' = all)
  '(format csv, header true)',          -- options
  'preksha-bucket-1',
  'Football-Dataset/player_performances.csv',
  'us-east-1'
) !!!RESOLVE EWI!!! /*** SSC-EWI-0073 - PENDING FUNCTIONAL EQUIVALENCE REVIEW FOR 'aws_s3.table_import_from_s3' NODE ***/!!!;

select * from
raw_schema.player_performance;