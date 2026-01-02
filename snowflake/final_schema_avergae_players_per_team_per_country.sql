select * from int_team_details;
select * from int_player_profile;

create or replace view final_schema.vw_average_players_per_team_per_country
 as
 SELECT
    t.country_name,
    round(COUNT(DISTINCT p.player_id) * 1.0 / COUNT(DISTINCT t.team_id)) AS avg_players_per_team
FROM intermediate_schema.int_player_profile p
JOIN intermediate_schema.int_team_details t ON p.current_team_id = t.team_id
GROUP BY t.country_name
ORDER BY avg_players_per_team DESC;

select * from final_schema.vw_average_players_per_team_per_country;


SELECT
    t.team_name,
    round(COUNT(DISTINCT p.player_id) * 1.0 / COUNT(DISTINCT t.team_id)) AS avg_players_per_team
FROM intermediate_schema.int_player_profile p
JOIN intermediate_schema.int_team_details t ON p.current_team_id = t.team_id
GROUP BY t.team_name
ORDER BY avg_players_per_team DESC;