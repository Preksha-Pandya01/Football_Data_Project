create table raw_schema.children_team(
parent_team_id integer,
parent_team_name text,
child_team_id integer,
child_team_name text,
_last_modified_at timestamp
);


SELECT aws_s3.table_import_from_s3(
  'raw_schema.children_team',                   -- target table
  '',                                   -- column list ('' = all)
  '(format csv, header true)',          -- options
  'preksha-bucket-1',
  'Football-Dataset/team_children.csv',
  'us-east-1'
);

-- select child_team_id, count(child_team_id)
-- from raw_schema.children_team
-- group by child_team_id
-- having count(child_team_id)>1;