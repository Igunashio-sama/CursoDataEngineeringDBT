{{ 
    config(
        materialized='view'
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
            , year(created_at)*10000+month(created_at)*100+day(created_at) as id_date_created
            , created_at as time_created
            , _fivetran_synced as date_load
            , _fivetran_deleted as is_deleted
        from src_sql_events
    )

select *
from renamed_casted