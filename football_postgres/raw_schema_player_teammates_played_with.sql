
--incremental configuration for player_teammates_played_with table.

create table raw_schema.player_teammates_played_with (
player_id integer,
teammate_player_id integer,
teammate_player_name text,
ppg_played_with float,
joint_goal_participation float,
minutes_played_with float,
load_at date default current_date   --new column added for the incremental logic
);


-- drop table raw_schema.player_teammates_played_with ;

SELECT aws_s3.table_import_from_s3(
  'raw_schema.player_teammates_played_with',                   -- target table
  'player_id,teammate_player_id,teammate_player_name,ppg_played_with,joint_goal_participation,minutes_played_with',                                   -- column list ('' = all)
  '(format csv, header true)',          -- options
  'preksha-bucket-1',
  'Football-Dataset/player_teammates_played_with.csv',
  'us-east-1'
);

select * from raw_schema.player_teammates_played_with;

