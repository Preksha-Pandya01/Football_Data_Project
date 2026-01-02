create or replace view final_schema.vw_injury_type_trends
COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 17,  "patch": "6.0" }, "attributes": {  "component": "postgresql",  "convertedOn": "09-18-2025",  "domain": "inferenz" }}'
as
SELECT
    pi.season_id,
    pi.injury_reason,
    COUNT(*) AS injury_count,
    SUM(pi.days_missed) AS total_days_missed
FROM
    intermediate_schema.int_player_injuries pi
GROUP BY pi.season_id, pi.injury_reason
ORDER BY injury_count DESC,season_id asc;

select * from final_schema.vw_injury_type_trends;