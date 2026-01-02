create or replace table raw_schema.transfer_history (
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
)
COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 17,  "patch": "6.0" }, "attributes": {  "component": "postgresql",  "convertedOn": "09-18-2025",  "domain": "inferenz" }}';
--** SSC-FDM-0007 - MISSING DEPENDENT OBJECT "aws_s3.table_import_from_s3" **
-- SELECT aws_s3.table_import_from_s3(
--   'raw_schema.transfer_history',                   -- target table
--   '',                                   -- column list ('' = all)
--   '(format csv, header true)',          -- options
--   'preksha-bucket-1',
--   'Football-Dataset/transfer_history.csv',
--   'us-east-1'
-- ) !!!RESOLVE EWI!!! /*** SSC-EWI-0073 - PENDING FUNCTIONAL EQUIVALENCE REVIEW FOR 'aws_s3.table_import_from_s3' NODE ***/!!!;

copy into raw_schema.transfer_history
    from @football_stage/transfer_history.csv
FILE_FORMAT =  'csv_reader';

select * from
raw_schema.transfer_history;

create or replace procedure raw_schema.raw_transfer_history()
returns string
language sql
as
$$
declare
path string;
command string;
begin

truncate table raw_schema.transfer_history;

SELECT relative_path into path FROM directory(@football_stage) WHERE relative_path LIKE '%transfer%' ORDER BY relative_path DESC limit 1;

command :='COPY INTO raw_schema.transfer_history FROM @football_stage/' || path || ' FILE_FORMAT = (FORMAT_NAME = ''csv_reader'')'; 

EXECUTE IMMEDIATE :command;

RETURN 'Data loaded from path: ' || path;
END;
$$; 

call raw_schema.raw_transfer_history();

select * from raw_schema.transfer_history;