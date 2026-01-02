create table intermediate_schema.int_player_market_value (
player_id integer,
date_unix date,
value integer
);


-- insert into intermediate_schema.int_player_market_value
-- select player_id,date_unix,value
-- from raw_schema.player_market_value;

create procedure intermediate_schema.int_player_market_value_proc()
language plpgsql
as $$
begin
insert into intermediate_schema.int_player_market_value
select
player_id,
date_unix,
value
from raw_schema.player_market_value ;
end;
$$;

call intermediate_schema.int_player_market_value_proc();


-- truncate intermediate_schema.int_player_market_value;

select * from intermediate_schema.int_player_market_value;