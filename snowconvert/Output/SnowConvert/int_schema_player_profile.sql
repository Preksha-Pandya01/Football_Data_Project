-- create table intermediate_schema.int_player_profile as (
-- select player_id,
-- player_slug
-- from raw_schema.player_profile
-- );

-- select * from intermediate_schema.int_player_profile;

-- select split_part(player_name, ' (', 1) from raw_schema.player_profile;

-- select player_id::integer,split_part(player_name, ' (', 1) as player_name,date_of_birth::date as date_of_birth,
-- country_of_birth,height::integer as height_in_cm,citizenship as Citizenship,is_eu,main_position,foot,current_club_id,
-- current_club_name,joined,contract_expires,player_agent_id,player_agent_name,TO_CHAR(TO_DATE(date_of_death, 'DD.MM.YYYY'), 'MM-DD-YYYY')::date
-- as date_of_death,replace(replace(split_part(date_of_death,' ',2),'(',' '),')',' ')::integer as age
-- from raw_schema.player_profile;

create table intermediate_schema.int_player_profile (
PLAYER_ID INTEGER PRIMARY KEY IDENTITY,
PLAYER_NAME TEXT,
DATE_OF_BIRTH DATE,
COUNTRY_OF_BIRTH TEXT,
HEIGHT_IN_CM INTEGER,
CITIZENSHIP TEXT,
IS_EU BOOLEAN,
MAIN_POSITION TEXT,
FOOT TEXT,
CURRENT_TEAM_ID INTEGER,
CURRENT_TEAM_NAME TEXT,
JOINED DATE,
CONTRACT_EXPIRES DATE,
PLAYER_AGENT_ID INTEGER,
PLAYER_AGENT_NAME TEXT,
DATE_OF_DEATH DATE,
AGE INTEGER
)
COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 17,  "patch": "6.0" }, "attributes": {  "component": "postgresql",  "convertedOn": "09-18-2025",  "domain": "inferenz" }}';


--drop table intermediate_schema.int_player_profile ;


CREATE OR REPLACE PROCEDURE intermediate_schema.int_player_profile_proc ()
RETURNS VARCHAR
LANGUAGE SQL
COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 17,  "patch": "6.0" }, "attributes": {  "component": "postgresql",  "convertedOn": "09-18-2025",  "domain": "inferenz" }}'
AS $$
BEGIN
    INSERT INTO intermediate_schema.int_player_profile
    SELECT
        player_id,
        SPLIT_PART(player_name, ' (', 1),
        date_of_birth,
        country_of_birth,
        height,
        citizenship,
        CASE WHEN is_eu = 'True' THEN True ELSE False END AS is_eu,
        main_position,
        foot,
        current_club_id,
        CASE WHEN current_club_name = '---' THEN NULL ELSE current_club_name END AS current_club_name,
        joined,
        contract_expires,
        player_agent_id,
        player_agent_name,
        TO_DATE(date_of_death, 'DD.MM.YYYY') AS date_of_death,
        CASE
            WHEN date_of_death IS NOT NULL
                 THEN EXTRACT(year FROM TO_DATE(date_of_death, 'DD.MM.YYYY')) - EXTRACT(year FROM date_of_birth)
            ELSE EXTRACT(year FROM CURRENT_DATE()) - EXTRACT(year FROM date_of_birth)
        END AS age
    FROM
        raw_schema.player_profile
    WHERE player_name IS NOT NULL;
END;
$$;


call intermediate_schema.int_player_profile_proc();


-- INSERT INTO intermediate_schema.int_player_profile 
-- select 
--     player_id,
--     split_part(player_name, ' (', 1),
--     date_of_birth,
--     country_of_birth,
--     height,
--     citizenship,
--     case when is_eu = 'True' then True else False end as is_eu,
--     main_position,
--     foot,
--     current_club_id,
--     case when current_club_name = '---' then null else current_club_name end as current_club_name,
--     joined,
--     contract_expires,
--     player_agent_id,
--     player_agent_name,
--     TO_DATE(date_of_death, 'DD.MM.YYYY') as date_of_death,
--     case 
--         when date_of_death is not null 
--              then extract(year from TO_DATE(date_of_death, 'DD.MM.YYYY')) - extract(year from date_of_birth)
--         else extract(year from current_date) - extract(year from date_of_birth)
--     end as age
-- from raw_schema.player_profile
-- where player_name is not null;

-- select * from intermediate_schema.int_player_profile;

--truncate intermediate_schema.int_player_profile;