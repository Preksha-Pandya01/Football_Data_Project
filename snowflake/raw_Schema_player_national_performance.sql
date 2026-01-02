create or replace table raw_schema.player_national_performance (
player_id integer,
team_id text,
team_name text,
first_game_date date,
matches integer,
goals integer
)
COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 17,  "patch": "6.0" }, "attributes": {  "component": "postgresql",  "convertedOn": "09-18-2025",  "domain": "inferenz" }}';

--drop table raw_schema.player_national_performance;
--** SSC-FDM-0007 - MISSING DEPENDENT OBJECT "aws_s3.table_import_from_s3" **
-- SELECT aws_s3.table_import_from_s3(
--   'raw_schema.player_national_performance',                   -- target table
--   '',                                   -- column list ('' = all)
--   '(format csv, header true)',          -- options
--   'preksha-bucket-1',
--   'Football-Dataset/player_national_performances.csv',
--   'us-east-1'
-- ) !!!RESOLVE EWI!!! /*** SSC-EWI-0073 - PENDING FUNCTIONAL EQUIVALENCE REVIEW FOR 'aws_s3.table_import_from_s3' NODE ***/!!!;

copy into raw_schema.PLAYER_NATIONAL_PERFORMANCE
from @football_stage/player_national_performances.csv
FILE_FORMAT =  'csv_reader';

select * from
raw_schema.player_national_performance;

create or replace procedure raw_schema.raw_player_national_performance()
returns string
language sql
as
$$
declare
path string;
command string;
begin

truncate table raw_schema.player_national_performance;

SELECT relative_path into path FROM directory(@football_stage) WHERE relative_path LIKE '%national%' ORDER BY relative_path DESC limit 1;

command :='COPY INTO raw_schema.player_national_performance FROM @football_stage/' || path || ' FILE_FORMAT = (FORMAT_NAME = ''csv_reader'')'; 

EXECUTE IMMEDIATE :command;

RETURN 'Data loaded from path: ' || path;
END;
$$; 

call raw_schema.raw_player_national_performance();

select * from raw_schema.player_national_performance;