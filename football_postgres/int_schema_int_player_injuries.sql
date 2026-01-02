
-- select * from raw_Schema.player_injuries where 
-- player_id=12589;

create table intermediate_schema.int_player_injuries (
player_id integer,
season_id text,
injury_reason text,
from_date date,
end_date date,
days_missed integer,
games_missed integer
); 

insert into intermediate_schema.int_player_injuries
select player_id,
season_name,
injury_reason,
from_date,
end_date,
days_missed,
games_missed
from raw_Schema.player_injuries;

delete from intermediate_schema.int_player_injuries
where from_date is null and end_date is null and days_missed is null and games_missed=0;

delete from intermediate_schema.int_player_injuries
where from_date is null and end_date is null and days_missed is null and games_missed>0;

delete from intermediate_schema.int_player_injuries
where from_date is null or end_date is null;

-- select * from intermediate_schema.int_player_injuries
-- where from_date is null;

-- select * from intermediate_schema.int_player_injuries
-- where end_date is null;

select * from intermediate_schema.int_player_injuries;

truncate intermediate_schema.int_player_injuries;
-- drop procedure intermediate_Schema.int_player_injuries_proc();
create procedure intermediate_Schema.int_player_injuries_proc()
language plpgsql
as $$
begin
insert into intermediate_schema.int_player_injuries
select
player_id,
season_name,
injury_reason,
from_date,
end_date,
days_missed,
games_missed
from raw_schema.player_injuries;

delete from intermediate_schema.int_player_injuries
where from_date is null and end_date is null and days_missed is null and games_missed=0;

delete from intermediate_schema.int_player_injuries
where from_date is null and end_date is null and days_missed is null and games_missed>0;

delete from intermediate_schema.int_player_injuries
where from_date is null or end_date is null;

end;
$$;

call intermediate_Schema.int_player_injuries_proc();