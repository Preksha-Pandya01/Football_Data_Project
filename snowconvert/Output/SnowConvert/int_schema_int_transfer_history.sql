
create table intermediate_schema.int_transfer_history (
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


drop table intermediate_schema.int_transfer_history;

truncate TABLE intermediate_schema.int_transfer_history;



insert into intermediate_schema.int_transfer_history
select player_id,
season_name,
transfer_date,
from_team_id,
from_team_name,
to_team_id,
to_team_name,
transfer_type,
value_at_transfer,
transfer_fee
from
raw_schema.transfer_history;

create procedure intermediate_Schema.int_transfer_history_proc ()
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
from_team_name,
to_team_id,
to_team_name,
transfer_type,
value_at_transfer,
transfer_fee
from
raw_schema.transfer_history;
end;
$$;

call intermediate_schema.int_transfer_history_proc();