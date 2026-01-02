create view final_schema.vw_highest_transfer_per_season as
select x.season_id,x.player_id,x.player_name,x.most_transfer_fee
from
(select t.season_id,
t.player_id,
max(p.player_name) as player_name,
max(t.transfer_fee) as most_transfer_fee,
row_number() over (partition by t.season_id order by max(t.transfer_fee) desc) as rank
from intermediate_schema.int_transfer_history t
join intermediate_schema.int_player_profile p on
t.player_id=p.player_id
group by t.season_id,t.player_id) x
where x.rank=1;

select * from final_schema.vw_highest_transfer_per_season;