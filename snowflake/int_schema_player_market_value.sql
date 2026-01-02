create or replace table intermediate_schema.int_player_market_value (
player_id integer,
date_unix date,
value integer
)
COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 17,  "patch": "6.0" }, "attributes": {  "component": "postgresql",  "convertedOn": "09-18-2025",  "domain": "inferenz" }}';

truncate table intermediate_schema.int_player_market_value;

-- insert into intermediate_schema.int_player_market_value
-- select player_id,date_unix,value
-- from raw_schema.player_market_value;

create or replace procedure intermediate_schema.int_player_market_value_proc ()
RETURNS VARCHAR
language SQL
COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 17,  "patch": "6.0" }, "attributes": {  "component": "postgresql",  "convertedOn": "09-18-2025",  "domain": "inferenz" }}'
as $$
begin
insert into intermediate_schema.int_player_market_value
select
player_id,
date_unix,
value
from
raw_schema.player_market_value;
end;
$$;

call intermediate_schema.int_player_market_value_proc();


-- truncate intermediate_schema.int_player_market_value;

select * from
intermediate_schema.int_player_market_value;

select player_id,max(date_unix),value
from intermediate_schema.int_player_market_value
group by player_id,value;