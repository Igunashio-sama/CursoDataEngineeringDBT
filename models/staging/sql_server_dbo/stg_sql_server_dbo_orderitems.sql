{{ 
    config(
        materialized='table'
    ) 
}}

with src_sql_orderitems as (
        select * 
        from {{ source("sql_server_dbo", "order_items") }}
    ),

    renamed_casted as (
        select
            order_id
            , product_id
            , quantity
            , _fivetran_synced as date_load
            , _fivetran_deleted as is_deleted
        from src_sql_orderitems
    )

select *
from renamed_casted