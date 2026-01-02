create table intermediate_schema.int_player_performance_overall (
player_id integer,
season_id text,
competition_id text,
competition_name text,
player_team_id integer,
player_team_name text,
matches_in_group integer,
matches_played_on_pitch integer,
goals integer,
assists integer,
own_goals integer,
times_subed_in integer,
times_subed_out integer,
yellow_cards integer,
second_yellow_cards integer,
direct_red_cards integer,
penalty_goals integer,
minutes_played integer,
goals_conceded integer,
clean_sheets integer,
primary key (player_id,season_id,competition_id,player_team_id)
)
COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 17,  "patch": "6.0" }, "attributes": {  "component": "postgresql",  "convertedOn": "09-18-2025",  "domain": "inferenz" }}';


create procedure intermediate_Schema.int_player_performance_overall_proc ()
RETURNS VARCHAR
language SQL
COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 17,  "patch": "6.0" }, "attributes": {  "component": "postgresql",  "convertedOn": "09-18-2025",  "domain": "inferenz" }}'
as $$
begin
insert into intermediate_schema.int_player_performance_overall
select
player_id,
season_id,
competition_id,
competition_name,
team_id,
team_name,
nb_in_group,
nb_on_pitch,
goals,
assists,
own_goals,
subed_in,
subed_out,
yellow_cards,
second_yellow_cards,
direct_red_cards,
penalty_goals,
minutes_played,
goals_conceded,
clean_sheets
from
raw_schema.player_performance
where goals is not null;

delete from
intermediate_schema.int_player_performance_overall
where minutes_played is null ;
end;
$$;


call intermediate_Schema.int_player_performance_overall_proc();


-- insert into intermediate_schema.int_player_performance_overall
-- select
-- player_id,
-- season_id,
-- competition_id,
-- competition_name,
-- team_id,
-- team_name,
-- nb_in_group,
-- nb_on_pitch,
-- goals,
-- assists,
-- own_goals,
-- subed_in,
-- subed_out,
-- yellow_cards,
-- second_yellow_cards,
-- direct_red_cards,
-- penalty_goals,
-- minutes_played,
-- goals_conceded,
-- clean_sheets
-- from raw_schema.player_performance
-- where goals is not null;

-- delete from intermediate_schema.int_player_performance_overall
-- where minutes_played is null ;

--truncate intermediate_schema.int_player_performance_overall;


select * from
intermediate_schema.int_player_performance_overall;