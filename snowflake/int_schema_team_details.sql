use database football_db;
create or replace table intermediate_schema.int_team_details (
team_id integer primary key,
team_slug string,
team_name string,
logo_url string,
country_name string,
season_id integer,
competition_id string,
competition_slug string,
competition_name string,
club_division string,
source_url string
);

create or replace procedure intermediate_schema.int_team_details_proc ()
RETURNS VARCHAR
language SQL
COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 17,  "patch": "6.0" }, "attributes": {  "component": "postgresql",  "convertedOn": "09-18-2025",  "domain": "inferenz" }}'
as $$
begin
insert into intermediate_schema.int_team_details
SELECT 
team_id,
club_slug,
split_part(club_name,' (', 1),
logo_url,
country_name,
season_id,
competition_id,
competition_slug,
competition_name,
club_division,
source_url
FROM raw_schema.team_details;
end;
$$;

call intermediate_schema.int_team_details_proc();


select * from intermediate_schema.int_team_details;

select * from raw_Schema.team_details;

alter table 