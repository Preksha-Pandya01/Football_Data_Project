create or replace view final_Schema_vw_top_teammates_pairs as 
SELECT 
    player_id,
    teammate_player_name,
    ROUND(AVG(ppg_played_with), 2) AS avg_ppg,
    SUM(minutes_played_with) AS total_minutes
FROM intermediate_schema.int_player_teammates_played_with
GROUP BY player_id, teammate_player_name
ORDER BY avg_ppg DESC
LIMIT 10;

select * from final_Schema_vw_top_teammates_pairs;

with cte as (SELECT 
    player_id,
    teammate_player_name,
    ROUND(AVG(ppg_played_with), 2) AS avg_ppg,
    SUM(minutes_played_with) AS total_minutes
FROM intermediate_schema.int_player_teammates_played_with
GROUP BY player_id, teammate_player_name
order by avg_ppg DESC
limit 10),

cte2 as (
select player_id,player_name
from intermediate_schema.int_player_profile
)

select cte2.player_name,cte.teammate_player_name,cte.avg_ppg,cte.total_minutes from
cte join cte2 on
cte.player_id::integer=cte2.player_id::integer;