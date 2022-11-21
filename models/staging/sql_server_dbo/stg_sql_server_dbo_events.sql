{{ 
    config(
        materialized='incremental', 
        unique_key='event_id',
        on_schema_change='fail'
    ) 
}}

with src_sql_events as (
        select * 
        from {{ source("sql_server_dbo", "events") }}
    ),

    renamed_casted as (
        select
            event_id
            , user_id
            , product_id
            , order_id
            , session_id
            , event_type
            , page_url
            , created_at::date AS creation_date
            , created_at::time AS creation_time
            , _fivetran_synced as date_load
            , _fivetran_deleted as is_deleted
        from src_sql_events
    )

select *
from renamed_casted
{% if is_incremental() %}
where date_load > (select max(date_load) from {{ this }})
{% endif %}
