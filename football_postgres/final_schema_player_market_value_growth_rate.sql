create view final_schema.vw_player_market_value_growth_rate as
select player_id,player_name,season_id,value,ROUND((value_growth * 100)::numeric, 2)::float as value_growth_rate
from (
select pm.player_id,
p.player_name,
extract(year from pm.date_unix) as season_id,
pm.value,
lag(pm.value) over (partition by pm.player_id order by extract(year from pm.date_unix)) as prev_value,
case when 
lag(pm.value) over (partition by pm.player_id order by extract(year from pm.date_unix)) is null 
then null
when 
lag(pm.value) over (partition by pm.player_id order by extract(year from pm.date_unix))=0 then null
else
((pm.value-lag(pm.value) over (partition by pm.player_id order by extract(year from pm.date_unix))::float)/lag(pm.value) over (partition by pm.player_id order by extract(year from pm.date_unix))::float)::FLOAT
end as value_growth
from intermediate_schema.int_player_market_value pm 
join intermediate_schema.int_player_profile p on
p.player_id=pm.player_id);

select * from final_schema.vw_player_market_value_growth_rate;

