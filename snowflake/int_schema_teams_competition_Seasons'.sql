-- select * from
-- raw_schema.team_competitions_seasons;

-- select club_id,
-- COUNT(competition_id)
-- from
-- raw_schema.team_competitions_seasons
-- group by club_id
-- order by
-- COUNT(competition_id) desc;

create or replace table intermediate_schema.int_team_competitions_seasons (
team_id integer primary key,
team_name text,
season_id integer,
competition_name text,
competition_id text
)
COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 17,  "patch": "6.0" }, "attributes": {  "component": "postgresql",  "convertedOn": "09-18-2025",  "domain": "inferenz" }}';

-- drop table intermediate_schema.int_team_competitions_seasons;

--split_part(team_name, ' (', 1)

select * from
raw_schema.team_competitions_seasons
where competition_name='Torneo Clausura';


select * from raw_schema.team_competitions_seasons;


create or replace procedure intermediate_schema.int_team_competitions_seasons_proc ()
RETURNS VARCHAR
language SQL
COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 17,  "patch": "6.0" }, "attributes": {  "component": "postgresql",  "convertedOn": "09-18-2025",  "domain": "inferenz" }}'
as $$
begin
insert into intermediate_schema.int_team_competitions_seasons
SELECT club_id,
       split_part(team_name,' (', 1),
       season_id,
       competition_name,
       competition_id
FROM raw_schema.team_competitions_seasons;
end;
$$;

call intermediate_schema.int_team_competitions_seasons_proc();

select * from
intermediate_schema.int_team_competitions_seasons;