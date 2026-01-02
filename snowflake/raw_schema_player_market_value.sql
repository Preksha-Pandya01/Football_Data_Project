create or replace table raw_schema.player_market_value (
player_id integer,
date_unix date,
value float
)
COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 17,  "patch": "6.0" }, "attributes": {  "component": "postgresql",  "convertedOn": "09-18-2025",  "domain": "inferenz" }}';

-- drop table raw_schema.player_market_value;
--** SSC-FDM-0007 - MISSING DEPENDENT OBJECT "aws_s3.table_import_from_s3" **
-- SELECT aws_s3.table_import_from_s3(
--   'raw_schema.player_market_value',                   -- target table
--   '',                                   -- column list ('' = all)
--   '(format csv, header true)',          -- options
--   'preksha-bucket-1',
--   'Football-Dataset/player_market_value.csv',
--   'us-east-1'
-- ) !!!RESOLVE EWI!!! /*** SSC-EWI-0073 - PENDING FUNCTIONAL EQUIVALENCE REVIEW FOR 'aws_s3.table_import_from_s3' NODE ***/!!!;


copy into raw_schema.PLAYER_MARKET_VALUE
from @football_stage/player_market_value.csv
FILE_FORMAT =  'csv_reader';


select * from
raw_schema.player_market_value;


SELECT relative_path  FROM directory(@football_stage) WHERE relative_path LIKE '%market%' ORDER BY relative_path DESC limit 1;

create or replace procedure raw_schema.raw_player_market_value()
returns string
language sql
as
$$
declare
path string;
command string;
begin

truncate table raw_schema.player_market_value;

SELECT relative_path into path FROM directory(@football_stage) WHERE relative_path LIKE '%market%' ORDER BY relative_path DESC limit 1;

command :='COPY INTO raw_schema.player_market_value FROM @football_stage/' || path || ' FILE_FORMAT = (FORMAT_NAME = ''csv_reader'')'; 

EXECUTE IMMEDIATE :command;

RETURN 'Data loaded from path: ' || path;
END;
$$; 

call raw_schema.raw_player_market_value();