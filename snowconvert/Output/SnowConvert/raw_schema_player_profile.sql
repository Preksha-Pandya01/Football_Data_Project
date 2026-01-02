create table raw_schema.player_profile (
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
--** SSC-FDM-0007 - MISSING DEPENDENT OBJECT "aws_s3.table_import_from_s3" **
SELECT aws_s3.table_import_from_s3(
  'raw_schema.player_profile',                   -- target table
  '',                                   -- column list ('' = all)
  '(format csv, header true)',          -- options
  'preksha-bucket-1',
  'Football-Dataset/player_profiles.csv',
  'us-east-1'
) !!!RESOLVE EWI!!! /*** SSC-EWI-0073 - PENDING FUNCTIONAL EQUIVALENCE REVIEW FOR 'aws_s3.table_import_from_s3' NODE ***/!!!;