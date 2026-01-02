create table intermediate_schema.int_children_team (
parent_team_id integer,
parent_team_name text,
child_team_id integer,
child_team_name text
)
COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 17,  "patch": "6.0" }, "attributes": {  "component": "postgresql",  "convertedOn": "09-18-2025",  "domain": "inferenz" }}'
;

insert into intermediate_schema.int_children_team
select
parent_team_id,
parent_team_name,
child_team_id,
child_team_name
from
raw_schema.children_team;


select * from
intermediate_schema.int_children_team;

truncate TABLE intermediate_schema.int_children_team;

create procedure intermediate_Schema.int_children_team_proc ()
RETURNS VARCHAR
language SQL
COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 17,  "patch": "6.0" }, "attributes": {  "component": "postgresql",  "convertedOn": "09-18-2025",  "domain": "inferenz" }}'
as $$
begin
insert into intermediate_schema.int_children_team
select
parent_team_id,
parent_team_name,
child_team_id,
child_team_name
from
raw_schema.children_team;
end;
$$;

call intermediate_Schema.int_children_team_proc();