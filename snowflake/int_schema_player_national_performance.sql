create or replace table intermediate_schema.int_player_national_performance (
player_id integer,
national_team_id text,
national_team_name text,
player_debut_game_date date,
matches_played_by_player integer,
goals_scored_by_player integer,
primary key (player_id,national_team_id)
)
COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 17,  "patch": "6.0" }, "attributes": {  "component": "postgresql",  "convertedOn": "09-18-2025",  "domain": "inferenz" }}'
;

-- WITH ranked AS (      --deleting the duplicates
--     SELECT ctid,  -- Postgres row identifier
--            ROW_NUMBER() OVER (
--                PARTITION BY player_id, team_id, team_name, first_game_date, matches, goals
--                ORDER BY player_id
--            ) AS rn
--     FROM raw_schema.player_national_performance
-- )
-- DELETE FROM raw_schema.player_national_performance
-- WHERE ctid IN (SELECT ctid FROM ranked WHERE rn > 1);

-- insert into intermediate_schema.int_player_national_performance
-- select player_id,
-- team_id,
-- replace(team_name,'-','N/A'),
-- first_game_date,
-- matches,
-- goals
-- from 
-- raw_schema.player_national_performance;

-- delete from intermediate_schema.int_player_national_performance
-- where national_team_name ='N/A';

-- delete from intermediate_schema.int_player_national_performance
-- where player_debut_game_date is null and matches_played_by_player>0 and goals_scored_by_player>0;

--truncate TABLE intermediate_schema.int_player_national_performance;

create or replace procedure intermediate_Schema.int_player_national_performance_proc ()
RETURNS VARCHAR
language SQL
COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 17,  "patch": "6.0" }, "attributes": {  "component": "postgresql",  "convertedOn": "09-18-2025",  "domain": "inferenz" }}'
as $$
begin


insert into intermediate_schema.int_player_national_performance
select 
player_id ,
team_id ,
team_name ,
first_game_date ,
matches ,
goals  
from raw_schema.player_national_performance;


end;
$$;

call intermediate_schema.int_player_national_performance_proc();

-- select top 1 * from
-- intermediate_schema.int_player_national_performance
-- where player_id=1079362 and national_team_id='OF19';




-- DELETE FROM raw_schema.player_national_performance
-- WHERE ctid IN (
--     SELECT ctid
--     FROM raw_schema.player_national_performance
--     WHERE player_id = 1079362
--       AND team_id = 'OF19'
--     LIMIT 1
-- );
select * from intermediate_schema.int_player_national_performance;

truncate intermediate_schema.int_player_national_performance;

-- insert into intermediate_schema.int_player_national_performance
-- select player_id,
-- team_id,
--     REPLACE(team_name,'-','N/A'),
-- first_game_date,
-- matches,
-- goals
-- from
--     raw_schema.player_national_performance;