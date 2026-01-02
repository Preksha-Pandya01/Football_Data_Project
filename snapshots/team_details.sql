{% snapshot team_details_snapshot %}
{{
        config(
          target_schema='snapshots',      
          unique_key='team_id',         
          strategy='check',               
          check_cols='all'  
        )
}}

    select * from {{ source('football_project', 'team_details') }}

{% endsnapshot %}