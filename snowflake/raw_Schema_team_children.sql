create or replace table raw_schema.children_team (
parent_team_id integer,
parent_team_name text,
child_team_id integer,
child_team_name text,
_last_modified_at timestamp
)
COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 17,  "patch": "6.0" }, "attributes": {  "component": "postgresql",  "convertedOn": "09-18-2025",  "domain": "inferenz" }}';
--** SSC-FDM-0007 - MISSING DEPENDENT OBJECT "aws_s3.table_import_from_s3" **
-- SELECT aws_s3.table_import_from_s3(
--   'raw_schema.children_team',                   -- target table
--   '',                                   -- column list ('' = all)
--   '(format csv, header true)',          -- options
--   'preksha-bucket-1',
--   'Football-Dataset/team_children.csv',
--   'us-east-1'
-- ) !!!RESOLVE EWI!!! /*** SSC-EWI-0073 - PENDING FUNCTIONAL EQUIVALENCE REVIEW FOR 'aws_s3.table_import_from_s3' NODE ***/!!!;

-- select child_team_id, count(child_team_id)
-- from raw_schema.children_team
-- group by child_team_id
-- having count(child_team_id)>1;

copy into raw_schema.children_team
    from @football_stage/team_children.csv
FILE_FORMAT =  'csv_reader';

create or replace procedure raw_schema.raw_children_team()
returns string
language sql
as
$$
declare
path string;
command string;
begin

truncate table raw_schema.children_team;

SELECT relative_path into path FROM directory(@football_stage) WHERE relative_path LIKE '%children%' ORDER BY relative_path DESC limit 1;

command :='COPY INTO raw_schema.children_team FROM @football_stage/' || path || ' FILE_FORMAT = (FORMAT_NAME = ''csv_reader'')'; 

EXECUTE IMMEDIATE :command;

RETURN 'Data loaded from path: ' || path;
END;
$$; 

call raw_schema.raw_children_team();

select * from raw_schema.children_team;