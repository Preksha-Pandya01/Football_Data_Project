create table intermediate_schema.int_children_team(
parent_team_id integer,
parent_team_name text,
child_team_id integer,
child_team_name text
)

insert into intermediate_schema.int_children_team
select
parent_team_id,
parent_team_name,
child_team_id,
child_team_name
from raw_schema.children_team;


select * from intermediate_schema.int_children_team;

truncate intermediate_schema.int_children_team;

create procedure intermediate_Schema.int_children_team_proc()
language plpgsql
as $$
begin
insert into intermediate_schema.int_children_team
select
parent_team_id,
parent_team_name,
child_team_id,
child_team_name
from raw_schema.children_team;
end;
$$;

call intermediate_Schema.int_children_team_proc();
