--select * from intermediate_schema.int_player_performance_overall;

CREATE OR REPLACE VIEW final_schema.vw_top_scorers_per_season AS
select player_id,
player_name,
season_id,
competition_id,
competition_name,
total_goals
from (
select p1.player_id,
max(p.player_name) as player_name,
p1.season_id,
p1.competition_id,
max(p1.competition_name) as competition_name,
sum(p1.goals) as total_goals,
rank() over (partition by p1.player_id order by sum(goals) desc) as goal_rank
from intermediate_schema.int_player_profile p
join intermediate_schema.int_player_performance_overall p1 on
p.player_id=p1.player_id
group by p1.player_id,p1.season_id,p1.competition_id) 
where goal_rank=1
order by total_goals desc;
