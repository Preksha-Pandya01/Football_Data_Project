create or replace table raw_schema.team_details (
team_id integer,
club_slug string,
club_name string,
logo_url string,
country_name string,
season_id integer,
competition_id string,
competition_slug string,
competition_name string,
club_division string,
source_url string,
last_modified_at timestamp
);


create or replace procedure raw_schema.raw_team_details_proc()
returns string
language sql
as
$$
declare
path string;
command string;
begin

truncate table raw_schema.team_details;

SELECT relative_path into path FROM directory(@football_stage) WHERE relative_path LIKE '%details%' ORDER BY relative_path DESC limit 1;

command :='COPY INTO raw_schema.team_details FROM @football_stage/' || path || ' FILE_FORMAT = (FORMAT_NAME = ''csv_reader'')'; 

EXECUTE IMMEDIATE :command;

RETURN 'Data loaded from path: ' || path;
END;
$$; 

call raw_schema.raw_team_details_proc();

select * from raw_schema.team_details;
