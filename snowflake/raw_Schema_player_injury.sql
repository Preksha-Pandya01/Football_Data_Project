create or replace table raw_schema.player_injuries (
player_id INTEGER IDENTITY,
season_name text,
injury_reason text,
from_date date,
end_date date,
days_missed float,
games_missed integer
)
COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 17,  "patch": "6.0" }, "attributes": {  "component": "postgresql",  "convertedOn": "09-18-2025",  "domain": "inferenz" }}';
--** SSC-FDM-0007 - MISSING DEPENDENT OBJECT "aws_s3.table_import_from_s3" **
-- SELECT aws_s3.table_import_from_s3(
--   'raw_schema.player_injuries',                   -- target table
--   '',                                   -- column list ('' = all)
--   '(format csv, header true)',          -- options
--   'preksha-bucket-1',
--   'Football-Dataset/player_injuries.csv',
--   'us-east-1'
-- ) !!!RESOLVE EWI!!! /*** SSC-EWI-0073 - PENDING FUNCTIONAL EQUIVALENCE REVIEW FOR 'aws_s3.table_import_from_s3' NODE ***/!!!;

copy into raw_schema.PLAYER_INJURIES
    from @football_stage/player_injuries.csv
FILE_FORMAT =  'csv_reader';

select * from
raw_schema.player_injuries where injury_reason is null;

create or replace procedure raw_schema.raw_player_injuries()
returns string
language sql
as
$$
declare
path string;
command string;
begin

truncate table raw_schema.player_injuries;

SELECT relative_path into path FROM directory(@football_stage) WHERE relative_path LIKE '%injuries%' ORDER BY relative_path DESC limit 1;

command :='COPY INTO raw_schema.player_injuries FROM @football_stage/' || path || ' FILE_FORMAT = (FORMAT_NAME = ''csv_reader'')'; 

EXECUTE IMMEDIATE :command;

RETURN 'Data loaded from path: ' || path;
END;
$$; 

call raw_schema.raw_player_injuries();

select * from raw_schema.player_injuries;