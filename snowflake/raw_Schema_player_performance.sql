create or replace table raw_schema.player_performance (
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
-- SELECT aws_s3.table_import_from_s3(
--   'raw_schema.player_performance',                   -- target table
--   '',                                   -- column list ('' = all)
--   '(format csv, header true)',          -- options
--   'preksha-bucket-1',
--   'Football-Dataset/player_performances.csv',
--   'us-east-1'
-- ) !!!RESOLVE EWI!!! /*** SSC-EWI-0073 - PENDING FUNCTIONAL EQUIVALENCE REVIEW FOR 'aws_s3.table_import_from_s3' NODE ***/!!!;

copy into raw_schema.PLAYER_PERFORMANCE
from @football_stage/player_performances.csv
FILE_FORMAT =  'csv_reader';



select * from
raw_schema.player_performance
where minutes_played is null;


create or replace procedure raw_schema.raw_player_performance()
returns string
language sql
as
$$
declare
path string;
command string;
begin

truncate table raw_schema.player_performance;

SELECT relative_path into path FROM directory(@football_stage) WHERE relative_path LIKE '%performance%' ORDER BY relative_path DESC limit 1;

command :='COPY INTO raw_schema.player_performance FROM @football_stage/' || path || ' FILE_FORMAT = (FORMAT_NAME = ''csv_reader'')'; 

EXECUTE IMMEDIATE :command;

RETURN 'Data loaded from path: ' || path;
END;
$$; 

call raw_schema.raw_player_performance();

select * from raw_schema.PLAYER_PROFILE;