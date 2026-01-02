create or replace table raw_schema.team_competitions_seasons (
club_id integer,
team_name text,
season_id text,
competition_name text,
competition_id text,
club_division text,
_last_modified_at timestamp
)
COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 17,  "patch": "6.0" }, "attributes": {  "component": "postgresql",  "convertedOn": "09-18-2025",  "domain": "inferenz" }}';
--** SSC-FDM-0007 - MISSING DEPENDENT OBJECT "aws_s3.table_import_from_s3" **
-- SELECT aws_s3.table_import_from_s3(
--   'raw_schema.team_competitions_seasons',                   -- target table
--   '',                                   -- column list ('' = all)
--   '(format csv, header true)',          -- options
--   'preksha-bucket-1',
--   'Football-Dataset/team_competitions_seasons.csv',
--   'us-east-1'
-- ) !!!RESOLVE EWI!!! /*** SSC-EWI-0073 - PENDING FUNCTIONAL EQUIVALENCE REVIEW FOR 'aws_s3.table_import_from_s3' NODE ***/!!!;

copy into raw_schema.team_competitions_seasons
    from @football_stage/team_competitions_seasons.csv
FILE_FORMAT =  'csv_reader';

select * from
raw_schema.team_competitions_seasons;

create or replace procedure raw_schema.raw_team_competitions_seasons()
returns string
language sql
as
$$
declare
path string;
command string;
begin

truncate table raw_schema.team_competitions_seasons;

SELECT relative_path into path FROM directory(@football_stage) WHERE relative_path LIKE '%competitions%' ORDER BY relative_path DESC limit 1;

command :='COPY INTO raw_schema.team_competitions_seasons FROM @football_stage/' || path || ' FILE_FORMAT = (FORMAT_NAME = ''csv_reader'')'; 

EXECUTE IMMEDIATE :command;

RETURN 'Data loaded from path: ' || path;
END;
$$; 

call raw_schema.raw_team_competitions_seasons();


SELECT relative_path  FROM directory(@football_stage) WHERE relative_path LIKE '%competitions%' ORDER BY relative_path DESC limit 1;

