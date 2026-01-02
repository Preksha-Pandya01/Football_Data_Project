create or replace view final_schema.vw_highest_transfer_per_season
COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 17,  "patch": "6.0" }, "attributes": {  "component": "postgresql",  "convertedOn": "09-18-2025",  "domain": "inferenz" }}'
as
select x.season_id,x.player_id,x.player_name,x.most_transfer_fee
from
(select t.season_id,
t.player_id,
MAX(p.player_name) as player_name,
MAX(t.transfer_fee) as most_transfer_fee,
ROW_NUMBER() over (partition by t.season_id order by
MAX(t.transfer_fee) desc) as rank
from
intermediate_schema.int_transfer_history t
join
intermediate_schema.int_player_profile p on
t.player_id=p.player_id
group by t.season_id,t.player_id) x
where x.rank=1;

select * from final_schema.vw_highest_transfer_per_season;