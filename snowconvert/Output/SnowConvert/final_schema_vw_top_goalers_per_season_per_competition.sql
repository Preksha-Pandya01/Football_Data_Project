--select * from intermediate_schema.int_player_performance_overall;

CREATE OR REPLACE VIEW final_schema.vw_top_scorers_per_season
COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 17,  "patch": "6.0" }, "attributes": {  "component": "postgresql",  "convertedOn": "09-18-2025",  "domain": "inferenz" }}'
AS
select player_id,
player_name,
season_id,
competition_id,
competition_name,
total_goals
from (
select p1.player_id,
MAX(p.player_name) as player_name,
p1.season_id,
p1.competition_id,
MAX(p1.competition_name) as competition_name,
SUM(p1.goals) as total_goals,
RANK() over (partition by p1.player_id order by
SUM(goals) desc) as goal_rank
from
intermediate_schema.int_player_profile p
join
intermediate_schema.int_player_performance_overall p1 on
p.player_id=p1.player_id
group by p1.player_id,p1.season_id,p1.competition_id)
where goal_rank=1
order by total_goals desc;