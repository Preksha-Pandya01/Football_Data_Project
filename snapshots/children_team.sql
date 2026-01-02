{% snapshot children_team_snapshot %}
{{
        config(
          target_schema='snapshots',      
          unique_key='child_team_id',         
          strategy='check',               
          check_cols='all'  
        )
}}

    select * from {{ source('football_project', 'children_team') }}

{% endsnapshot %}