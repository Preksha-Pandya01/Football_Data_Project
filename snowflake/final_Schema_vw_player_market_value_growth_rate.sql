create or replace view final_schema.vw_player_market_value_growth_rate
COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 17,  "patch": "6.0" }, "attributes": {  "component": "postgresql",  "convertedOn": "09-18-2025",  "domain": "inferenz" }}'
as
select player_id,player_name,season_id,value,
ROUND((value_growth * 100)::numeric, 2)::float as value_growth_rate
from (
select pm.player_id,
p.player_name,
extract(year from pm.date_unix) as season_id,
pm.value,
LAG(pm.value) over (partition by pm.player_id order by extract(year from pm.date_unix)) as prev_value,
case when LAG(pm.value) over (partition by pm.player_id order by extract(year from pm.date_unix)) is null
then null
when LAG(pm.value) over (partition by pm.player_id order by extract(year from pm.date_unix))=0 then null
else
((pm.value- LAG(pm.value) over (partition by pm.player_id order by extract(year from pm.date_unix))::float)/ LAG(pm.value) over (partition by pm.player_id order by extract(year from pm.date_unix))::float)::FLOAT
end as value_growth
from
intermediate_schema.int_player_market_value pm
join
intermediate_schema.int_player_profile p on
p.player_id=pm.player_id);

select * from final_schema.vw_player_market_value_growth_rate
order by player_id asc,value_growth_rate desc;

select max(value_growth_rate) from
final_schema.vw_player_market_value_growth_rate;

select * from final_schema.vw_player_market_value_growth_rate
where value_growth_rate=(select max(value_growth_rate) from
final_schema.vw_player_market_value_growth_rate );

select * from final_schema.vw_player_market_value_growth_rate
where player_id=275381;

select * from final_schema.vw_player_market_value_growth_rate
where player_id=275381;


select max(value_growth_rate)
from final_schema.vw_player_market_value_growth_rate;

select min(value_growth_rate)
from final_schema.vw_player_market_value_growth_rate;

select * from final_schema.vw_player_market_value_growth_rate
where player_name ='Adam Webster';

select * from
final_schema.vw_player_market_value_growth_rate
where player_id=275381
and season_id=2019;