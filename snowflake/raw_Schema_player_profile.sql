create or replace file format csv_reader
type='CSV'
skip_header=1
field_optionally_enclosed_by='"'
error_on_column_count_mismatch=false;





create or replace table raw_schema.player_profile (
player_id integer,
player_slug text,
player_name text,
player_image_url text,
name_in_home_country text,
date_of_birth date,
place_of_birth text,
country_of_birth text,
height float,
citizenship text,
is_eu text,
position text,
main_position text,
foot text,
current_club_id integer,
current_club_name text,
joined date,
contract_expires date,
outfitter text,
social_media_url text,
player_agent_id integer,
player_agent_name text,
contract_option text,
date_of_last_contract_extension date,
on_loan_from_club_id integer,
on_loan_from_club_name text,
contract_there_expires date,
second_club_url text,
second_club_name text,
third_club_url text,
third_club_name text,
fourth_club_url text,
fourth_club_name text,
date_of_death text
)
COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 17,  "patch": "6.0" }, "attributes": {  "component": "postgresql",  "convertedOn": "09-18-2025",  "domain": "inferenz" }}';

-- SELECT aws_s3.table_import_from_s3(
--   'raw_schema.player_profile',                   -- target table
--   '',                                   -- column list ('' = all)
--   '(format csv, header true)',          -- options
--   'preksha-bucket-1',
--   'Football-Dataset/player_profiles.csv',
--   'us-east-1'
-- );

-- copy into raw_schema.PLAYER_PROFILE
-- from @football_stage/player_profiles.csv
-- FILE_FORMAT =  'csv_reader';

select * from raw_schema.PLAYER_PROFILE;

select player_id,player_slug,player_name,player_image_url,name_in_home_country,date_of_birth,place_of_birth from raw_schema.player_profile;

SELECT relative_path FROM directory(@football_stage) WHERE relative_path LIKE '%profile%' ORDER BY relative_path DESC limit 1; 

-- copy into raw_schema.PLAYER_PROFILE
-- from (SELECT "@football_stage/" + relative_path FROM directory(@football_stage) WHERE relative_path LIKE '%profile%' ORDER BY relative_path DESC limit 1)
-- FILE_FORMAT =  'csv_reader';

create or replace procedure raw_schema.raw_player_profile()
returns string
language sql
as
$$
declare
path string;
command string;
begin

truncate table raw_schema.player_profile;

SELECT relative_path into path FROM directory(@football_stage) WHERE relative_path LIKE '%profile%' ORDER BY relative_path DESC limit 1;

command :='COPY INTO raw_schema.player_profile FROM @football_stage/' || path || ' FILE_FORMAT = (FORMAT_NAME = ''csv_reader'')'; 

EXECUTE IMMEDIATE :command;

RETURN 'Data loaded from path: ' || path;
END;
$$; 

call raw_schema.raw_player_profile();

select * from raw_schema.PLAYER_PROFILE;

SELECT relative_path  FROM directory(@football_stage) WHERE relative_path LIKE '%profile%' ORDER BY relative_path;
