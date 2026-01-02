
--incremental configuration for player_teammates_played_with table.

create or replace table raw_schema.player_teammates_played_with (
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
-- SELECT aws_s3.table_import_from_s3(
--   'raw_schema.player_teammates_played_with',                   -- target table
--   'player_id,teammate_player_id,teammate_player_name,ppg_played_with,joint_goal_participation,minutes_played_with',                                   -- column list ('' = all)
--   '(format csv, header true)',          -- options
--   'preksha-bucket-1',
--   'Football-Dataset/player_teammates_played_with.csv',
--   'us-east-1'
-- ) !!!RESOLVE EWI!!! /*** SSC-EWI-0073 - PENDING FUNCTIONAL EQUIVALENCE REVIEW FOR 'aws_s3.table_import_from_s3' NODE ***/!!!;

-- copy into raw_schema.PLAYER_TEAMMATES_PLAYED_WITH
-- from @football_stage/player_teammates_played_with.csv
-- FILE_FORMAT =  'csv_reader';

COPY INTO raw_schema.player_teammates_played_with
FROM (
    SELECT
        t.$1::integer,
        t.$2::integer,
        t.$3::text,
        t.$4::float,
        t.$5::float,
        t.$6::float,
        CURRENT_DATE()
    FROM @football_stage/player_teammates_played_with.csv 
    (FILE_FORMAT => 'csv_reader') t
);



select * from
raw_schema.player_teammates_played_with;


create or replace procedure raw_schema.raw_player_teammates_played_with()
returns string
language sql
as
$$
declare
path string;
command string;
begin

truncate table raw_schema.player_teammates_played_with;

SELECT relative_path into path FROM directory(@football_stage) WHERE relative_path LIKE '%teammates%' ORDER BY relative_path DESC limit 1;

command :='COPY INTO raw_schema.player_teammates_played_with
                FROM (
                    SELECT
                        t.$1::integer,
                        t.$2::integer,
                        t.$3::text,
                        t.$4::float,
                        t.$5::float,
                        t.$6::float,
                        CURRENT_DATE()::date as load_at
                    FROM @football_stage/' || path || ' t
                )
                FILE_FORMAT = (FORMAT_NAME = ''csv_reader'');';

EXECUTE IMMEDIATE command;

RETURN 'Data loaded from path: ' || path;
END;
$$; 

call raw_schema.raw_player_teammates_played_with();

select * from raw_schema.player_teammates_played_with;

