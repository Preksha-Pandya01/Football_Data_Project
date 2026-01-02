-- select * from raw_schema.player_teammates_played_with
-- where minutes_played_with is null;  --drop from intermediate schema

-- select * from raw_schema.player_teammates_played_with
-- where ppg_played_with is null and joint_goal_participation is not null and minutes_played_with >=0;

create table intermediate_schema.int_player_teammates_played_with(
player_id integer,
teammate_player_id integer,
teammate_player_name text,
ppg_played_with float,
joint_goal_participation integer,
minutes_played_with integer,
primary key (player_id,teammate_player_id));

insert into intermediate_schema.int_player_teammates_played_with 
select player_id,
teammate_player_id,
teammate_player_name,
coalesce(ppg_played_with,0)::float,
coalesce(joint_goal_participation,0)::integer,
minutes_played_with
from raw_schema.player_teammates_played_with
where load_at=current_date and
minutes_played_with is not null;

-- select * from intermediate_schema.int_player_teammates_played_with
-- where ppg_played_with=0 or minutes_played_with=0 or joint_goal_participation=0;

select * from intermediate_schema.int_player_teammates_played_with;

truncate intermediate_schema.int_player_teammates_played_with;

create procedure intermediate_schema.int_player_teammates_played_with_proc()
language plpgsql
as $$
begin
insert into intermediate_schema.int_player_teammates_played_with
select
player_id,
teammate_player_id,
teammate_player_name,
coalesce(ppg_played_with,0)::float,
coalesce(joint_goal_participation,0)::integer,
minutes_played_with
from raw_schema.player_teammates_played_with
where load_at=current_date and
minutes_played_with is not null;
end;
$$;

--drop procedure intermediate_schema.int_player_teammates_played_with_proc();

call intermediate_schema.int_player_teammates_played_with_proc();

select * from intermediate_schema.int_player_teammates_played_with;