
--incremental configuration for player_teammates_played_with table.

create table raw_schema.player_teammates_played_with (
player_id integer,
teammate_player_id integer,
teammate_player_name text,
ppg_played_with float,
joint_goal_participation float,
minutes_played_with float,
load_at date default CURRENT_DATE() --new column added for the incremental logic
)
COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 17,  "patch": "6.0" }, "attributes": {  "component": "postgresql",  "convertedOn": "09-18-2025",  "domain": "inferenz" }}';


-- drop table raw_schema.player_teammates_played_with ;
--** SSC-FDM-0007 - MISSING DEPENDENT OBJECT "aws_s3.table_import_from_s3" **
SELECT aws_s3.table_import_from_s3(
  'raw_schema.player_teammates_played_with',                   -- target table
  'player_id,teammate_player_id,teammate_player_name,ppg_played_with,joint_goal_participation,minutes_played_with',                                   -- column list ('' = all)
  '(format csv, header true)',          -- options
  'preksha-bucket-1',
  'Football-Dataset/player_teammates_played_with.csv',
  'us-east-1'
) !!!RESOLVE EWI!!! /*** SSC-EWI-0073 - PENDING FUNCTIONAL EQUIVALENCE REVIEW FOR 'aws_s3.table_import_from_s3' NODE ***/!!!;

select * from
raw_schema.player_teammates_played_with;