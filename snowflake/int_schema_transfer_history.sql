
create or replace table intermediate_schema.int_transfer_history (
player_id integer,
season_id text,
transfer_date date,
from_team_id integer,
from_team_name text,
to_team_id integer,
to_team_name text,
transfer_type text,
value_at_transfer integer,
transfer_fee integer
)
COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 17,  "patch": "6.0" }, "attributes": {  "component": "postgresql",  "convertedOn": "09-18-2025",  "domain": "inferenz" }}';


-- drop table intermediate_schema.int_transfer_history;

-- truncate TABLE intermediate_schema.int_transfer_history;



-- insert into intermediate_schema.int_transfer_history
-- select player_id,
-- season_name,
-- transfer_date,
-- from_team_id,
-- from_team_name,
-- to_team_id,
-- to_team_name,
-- transfer_type,
-- value_at_transfer,
-- transfer_fee
-- from
-- raw_schema.transfer_history;

create or replace procedure intermediate_Schema.int_transfer_history_proc ()
RETURNS VARCHAR
language SQL
COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 17,  "patch": "6.0" }, "attributes": {  "component": "postgresql",  "convertedOn": "09-18-2025",  "domain": "inferenz" }}'
as $$
begin
insert into intermediate_schema.int_transfer_history
select player_id,
season_name,
transfer_date,
from_team_id,
case when from_team_name='Without Club' then 'Free Player'
else from_team_name
end as from_team_name,
to_team_id,
case when to_team_name='Without Club' then 'Free Player'
else to_team_name
end as to_team_name,
transfer_type,
value_at_transfer,
transfer_fee
from
raw_schema.transfer_history;

delete from intermediate_schema.int_transfer_history
where season_id in ('26/27','27/28');

delete from intermediate_Schema.int_transfer_history
where year(transfer_date)::integer>2025;

end;
$$;

call intermediate_schema.int_transfer_history_proc();

select * from intermediate_schema.int_transfer_history
where to_team_name='Free Player';

select distinct(to_team_name) from intermediate_schema.int_transfer_history;

select distinct(from_team_name) from raw_schema.transfer_history;

select * from intermediate_schema.int_transfer_history;

select season_id,player_id,count(player_id)
from intermediate_schema.int_transfer_history
group by season_id,player_id 
having player_id = 2857
order by count(player_id) desc;