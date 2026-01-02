{% snapshot cdc_problem_snapshot_dbt_core %}
{{
        config(
          target_schema='snapshots',      
          unique_key='location_id',         
          strategy='check',               
          check_cols='all' ,
          hard_deletes = 'invalidate' 
        )
}}

    select distinct * from {{ source('cdc_problem', 'source_location') }}

{% endsnapshot %}