-- SELECT 
--     tcs.competition_id,
--     tcs.competition_name,
--     tcs.season_id,
--     (SELECT p.player_name 
--      FROM intermediate_schema.int_player_performance_overall pp 
--      JOIN intermediate_schema.int_player_profile p ON pp.player_id = p.player_id
--      WHERE pp.competition_id = tcs.competition_id AND pp.season_id = tcs.season_id
--      ORDER BY pp.goals DESC LIMIT 1) AS top_scorer,
--     (SELECT p.player_name 
--      FROM intermediate_schema.int_player_performance pp 
--      JOIN intermediate_schema.int_player_profile p ON pp.player_id = p.player_id
--      WHERE pp.competition_id = tcs.competition_id AND pp.season_id::text = tcs.season_id::text
--      ORDER BY pp.assists DESC LIMIT 1) AS top_assister
-- FROM intermediate_schema.int_team_competitions_seasons tcs;

select * from intermediate_schema.int_player_injuries;

create view final_schema.vw_injury_burden_per_team_per_season as
SELECT 
    t.team_id,
    max(t.team_name) as team_name,
    pi.season_id,
    SUM(pi.days_missed) AS total_days_lost,
    SUM(pi.games_missed) AS total_games_lost,
    COUNT(DISTINCT pi.player_id) AS affected_players
FROM intermediate_Schema.int_player_injuries pi
JOIN intermediate_schema.int_player_profile p ON pi.player_id = p.player_id
JOIN intermediate_schema.int_team_competitions_seasons t ON p.current_team_id = t.team_id
GROUP BY t.team_id, pi.season_id;

select * from final_schema.vw_injury_burden_per_team_per_season;