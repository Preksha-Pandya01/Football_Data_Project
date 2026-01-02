create or replace view final_Schema_vw_team_competitions_Summary as
SELECT
    country_name,
    COUNT(DISTINCT team_id) AS total_teams,
    COUNT(DISTINCT competition_id) AS total_competitions
FROM intermediate_schema.int_team_details
GROUP BY country_name
ORDER BY total_teams DESC;


select * from final_Schema_vw_team_competitions_Summary;
