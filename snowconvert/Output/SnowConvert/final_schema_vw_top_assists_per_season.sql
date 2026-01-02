--top assists per season

select * from
intermediate_Schema.int_player_performance_overall
where player_id=410547;

create view final_schema.vw_top_assists_per_season
COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 17,  "patch": "6.0" }, "attributes": {  "component": "postgresql",  "convertedOn": "09-18-2025",  "domain": "inferenz" }}'
as
select player_id,
player_name,
season_id,
team_name,
total_assists
from (
select p.player_id,
MAX(p1.player_name) as player_name,
p.season_id,
MAX(p.player_team_name) as team_name,
SUM(p.assists) as total_assists,
RANK() over (partition by p.player_id order by
SUM(p.assists) desc) as rank
FROM
intermediate_schema.int_player_performance_overall p
JOIN
intermediate_schema.int_player_profile p1 ON p.player_id = p1.player_id
group by p.player_id,p.season_id) x
where
rank=1
order by total_assists desc;