create view final_schema.vw_injury_type_trends as
SELECT 
    pi.season_id,
    pi.injury_reason,
    COUNT(*) AS injury_count,
    SUM(pi.days_missed) AS total_days_missed
FROM intermediate_schema.int_player_injuries pi
GROUP BY pi.season_id, pi.injury_reason
ORDER BY injury_count DESC,season_id asc;

select * from final_schema.vw_injury_type_trends;

