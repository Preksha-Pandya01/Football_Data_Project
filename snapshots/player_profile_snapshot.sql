{% snapshot player_profile_snapshot %}
{{
        config(
          target_schema='snapshots',      
          unique_key='player_id',         
          strategy='check',               
          check_cols='all'  
        )
}}

    select * from {{ source('football_project', 'player_profile') }}

{% endsnapshot %}