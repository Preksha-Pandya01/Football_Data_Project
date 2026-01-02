select * from raw_schema.team_competitions_seasons;

select club_id,count(competition_id)
from raw_schema.team_competitions_seasons
group by club_id
order by count(competition_id) desc;

create table intermediate_schema.int_team_competitions_seasons(
team_id integer primary key,
team_name text,
season_id integer,
competition_name text,
competition_id text
);

-- drop table intermediate_schema.int_team_competitions_seasons;

--split_part(team_name, ' (', 1)

select * from raw_schema.team_competitions_seasons;

insert into intermediate_schema.int_team_competitions_seasons
select
club_id,
split_part(team_name, ' (', 1),
season_id::integer,
competition_name,
competition_id
from raw_schema.team_competitions_seasons;

select * from intermediate_schema.int_team_competitions_seasons;

-- truncate intermediate_schema.int_team_competitions_seasons;

create procedure intermediate_schema.int_team_competitions_seasons_proc()
language plpgsql
as $$
begin
insert into intermediate_schema.int_team_competitions_seasons
select
club_id,
split_part(team_name, ' (', 1),
season_id::integer,
competition_name,
competition_id
from raw_schema.team_competitions_seasons;
end;
$$;

call intermediate_schema.int_team_competitions_seasons_proc();