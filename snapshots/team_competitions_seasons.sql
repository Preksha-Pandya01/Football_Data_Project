{% snapshot team_competitions_seasons_snapshot %}
{{
        config(
          target_schema='snapshots',      
          unique_key='club_id',         
          strategy='check',               
          check_cols='all'  
        )
}}

    select * from {{ source('football_project', 'team_competitions_seasons') }}

{% endsnapshot %}