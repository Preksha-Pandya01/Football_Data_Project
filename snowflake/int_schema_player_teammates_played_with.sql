-- select * from raw_schema.player_teammates_played_with
-- where minutes_played_with is null;  --drop from intermediate schema

-- select * from raw_schema.player_teammates_played_with
-- where ppg_played_with is null and joint_goal_participation is not null and minutes_played_with >=0;

create or replace table intermediate_schema.int_player_teammates_played_with (
player_id integer,
teammate_player_id integer,
teammate_player_name text,
ppg_played_with float,
joint_goal_participation integer,
minutes_played_with integer,
primary key (player_id,teammate_player_id))
COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 17,  "patch": "6.0" }, "attributes": {  "component": "postgresql",  "convertedOn": "09-18-2025",  "domain": "inferenz" }}';

-- insert into intermediate_schema.int_player_teammates_played_with
-- select player_id,
-- teammate_player_id,
-- teammate_player_name,
-- COALESCE(ppg_played_with,0)::float,
-- COALESCE(joint_goal_participation,0)::integer,
-- minutes_played_with
-- from
-- raw_schema.player_teammates_played_with
-- where load_at= CURRENT_DATE()
-- and
-- minutes_played_with is not null;

-- select * from intermediate_schema.int_player_teammates_played_with
-- where ppg_played_with=0 or minutes_played_with=0 or joint_goal_participation=0;

--truncate TABLE intermediate_schema.int_player_teammates_played_with;

create or replace procedure intermediate_schema.int_player_teammates_played_with_proc ()
RETURNS VARCHAR
language SQL
COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 17,  "patch": "6.0" }, "attributes": {  "component": "postgresql",  "convertedOn": "09-18-2025",  "domain": "inferenz" }}'
as $$
begin
insert into intermediate_schema.int_player_teammates_played_with
select
player_id,
teammate_player_id,
teammate_player_name,
ppg_played_with,
joint_goal_participation,
minutes_played_with
from
raw_schema.player_teammates_played_with
where load_at= CURRENT_DATE();
end;
$$;

--drop procedure intermediate_schema.int_player_teammates_played_with_proc();

call intermediate_schema.int_player_teammates_played_with_proc();

select * from
intermediate_schema.int_player_teammates_played_with;


select * from raw_schema.player_teammates_played_with
where minutes_played_with is null;